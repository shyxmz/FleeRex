extends Node

#camera and trex initial posi
const TREX_START_POSI = Vector2(152,608)
const CAMERA_START_POSI = Vector2(640,384)
var score_timer:float = 0
var score = 0
var time_interval: float = 0.1
var game_running = false
const SPEED_MOD = 50

#speed of trex
var speed: float
const START_SPEED: float = 10
const MAX_SPEED: float = 30
var screen_size = Vector2i(0,0)
var ground_height
var max_obs = 0
# to store the last_obs created 


#preloading obstacle scenes 
var ob1 = preload("res://scenes/obstacle_1.tscn")
var ob2 = preload("res://scenes/obstacle_2.tscn")
var ob3 = preload("res://scenes/obstacle_3.tscn")
var ob4 = preload("res://scenes/obstacle_4.tscn")
var ob5 = preload("res://scenes/obstacle_5.tscn")
var bird = preload("res://scenes/bird.tscn")
#grouping obstacles together in a array
var ob_types: = [ob1,ob2,ob3,ob4,ob5]
var ob_index = 0
#array to track obstacles we have created
var obs: Array
#spawning birds at two height- one for jumping and one for ducking
var bird_height: = [544,608,480]
var last_obs 

#Executed once after node is added to the scene tree and all its child nodes are ready 
#So this will run as soon as the game runs 
func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	ground_height = $ground.get_node("Sprite2D").texture.get_height()
	$gameOver.get_node("restart").pressed.connect(new_game)
	new_game()

func new_game():
	game_running = false
	get_tree().paused = false
	score = 0
	show_score()
	$trex.position = TREX_START_POSI
	$trex.velocity = Vector2i(0,0)
	$gameCamera.position = CAMERA_START_POSI
	$ground.position = Vector2i(0,0)
	$HUD.get_node("play").show()
	$gameOver.get_node("restart").hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running == true:
		if speed < MAX_SPEED:
			# increases the speed uniformly 
			speed = START_SPEED + score / SPEED_MOD
		print(speed)
		#Generate obstacles before trex starts moving forward
		generate_obs() 
		$trex.position.x += speed
		$gameCamera.position.x += speed
		
		
		# In order to increase the score at a slow pace 
		score_timer += delta
		# If the score timer exceeds the 0.3 mark then reset the score timer and increment the score by 1 
		if score_timer > time_interval:
			score_timer -= time_interval
			score += 1
			show_score()
		if $gameCamera.position.x - $ground.position.x > screen_size.x * 1.5:
			$ground.position.x += screen_size.x
			
		# dump the obstacles that are that the trex has passed 
		for ob in obs:
			if ob.position.x < ($gameCamera.position.x-screen_size.x):
				ob.queue_free()
				obs.erase(ob)
				
			
	else:
		if Input.is_action_pressed("trex_jump"):
			game_running = true
			$HUD.get_node("play").hide()
			
#ground obstacles
func generate_obs():
	if obs.is_empty() or last_obs.position.x < $gameCamera.position.x + randi_range(300,600):
		if speed < 15:
			max_obs = 1
			create_ob_cluster(max_obs)
		elif speed >= 15 and speed < 20:
			max_obs = 2
			create_ob_cluster(max_obs)
		else:
			max_obs = 3
			create_ob_cluster(max_obs)
			
func create_ob_cluster(max_obs):
	ob_index = randi_range(0,4)
	var obs_type_gen = ob_types[ob_index] 
	for i in range(randi()%max_obs+1):
		var ob = obs_type_gen.instantiate() # instantiating obs from array
		var ob_height = ob.get_node("Sprite2D").texture.get_height()
		var ob_scale = ob.get_node("Sprite2D").scale
		var ob_x: int = screen_size.x + $gameCamera.position.x + 700 + (i*120) # multiplied i in-order to space out multiple obstacles that are put together
		var ob_y: int = screen_size.y - ground_height - (ob_height*ob_scale.y / 2) + 8 
		last_obs = ob
		create_new_obs(ob,ob_x,ob_y)
	

func create_new_obs(ob, x, y):
	var y1 = y+15
	ob.position = Vector2i(x,y1)
	ob.body_entered.connect(hit_ob)
	add_child(ob) # adding obs to the scene
	obs.append(ob) # adding obs to the created obs array 
	
		
func hit_ob(body):
	if body.name == "trex":
		game_over()
		
func game_over():
	get_tree().paused = true
	game_running = false
	$gameOver.get_node("restart").show()
	
	
		
		
#display score
func show_score():
	$HUD.get_node("score").text = "SCORE: " + str(score)
	
	
	# to load the map infinitely ->
	# We kept our camera in the middle of the screen so as soon as the 
	# camera moves of too far and the ground is about to go off the screen
	# we will shift the ground along by the width of screen
	
	
