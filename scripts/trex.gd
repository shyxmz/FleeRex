extends CharacterBody2D

const GRAVITY: int = 200
const JUMP_VELOCITY: int = -1900



func _ready() -> void:
	pass
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY*delta
		$trexAnimation.play("jump")
		
	if is_on_floor():
		if not get_parent().game_running:
			$trexAnimation.play("idle")
		else:
			var area = $trexArea
			$runCollision.disabled = false
			if Input.is_action_pressed("jump"):
				#$jumpSound.play()
				velocity.y = JUMP_VELOCITY
			else:
				$trexAnimation.play("run")
	move_and_slide()
	
