class_name IdlePlayerState extends PlayerMovementState

func enter() -> void:
	player.velocity = Vector3.ZERO


func physics_update(_delta : float):
	
	if Input.get_vector("walk_left", "walk_right", "walk_forwards", "walk_backwards") != Vector2.ZERO:
		transition.emit("WalkingPlayerState")
		
	if Input.is_action_pressed("crouch"):
		transition.emit("CrouchingPlayerState")
