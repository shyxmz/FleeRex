extends CharacterBody2D

const GRAVITY: int = 4200
const JUMP_VELOCITY: int = -1900


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY*delta
		$trexAnimation.play("jump")
		
	if is_on_floor():
		if not get_parent().game_running:
			$trexAnimation.play("idle")
		else:
			$runCollision.disabled = false
			if Input.is_action_pressed("trex_jump"):
				$jumpSound 
				$jumpSound.play() 
				velocity.y = JUMP_VELOCITY
			elif Input.is_action_pressed("trex_duck"):
				$trexAnimation.play("duck")
				$runCollision.disabled = true
			else:
				$trexAnimation.play("run")
		
	move_and_slide()
