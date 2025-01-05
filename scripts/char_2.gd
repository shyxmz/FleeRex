extends CharacterBody2D

const GRAVITY: int = 4200
const JUMP_VELOCITY: int = -1900



func _ready() -> void:
	pass
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY*delta
		$char2Animation.play("jump")
	if is_on_floor():
		if not get_parent().game_running:
			$char2Animation.play("idle")
		else:
			$runCollision.disabled = false
			if Input.is_action_pressed("jump"):
				$char2Animation.play("jump")
				velocity.y = JUMP_VELOCITY
			else:
				$char2Animation.play("run")
	move_and_slide()
		
	
