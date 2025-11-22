class_name SprintingPlayerState extends PlayerMovementState

func enter() -> void:
	player.speed = player.sprinting_speed


func physics_update(delta : float) -> void:
	player.update_gravity(delta)
	player.update_movement()
	player.update_velocity()

	if player.velocity == Vector3.ZERO:
		transition.emit("IdlePlayerState")
		
	if Input.is_action_just_released("sprint"): 
		transition.emit("WalkingPlayerState")

	if Input.is_action_pressed("crouch"):
		transition.emit("CrouchingPlayerState")

	if Input.is_action_pressed("crouch"):
		transition.emit("CrouchingPlayerState")
