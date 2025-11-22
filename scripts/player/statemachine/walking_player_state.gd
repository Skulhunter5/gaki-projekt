class_name WalkingPlayerState extends PlayerMovementState

func enter() -> void:
	player.speed = player.walking_speed	

func physics_update(delta : float):
	if player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")
		
	if Input.is_action_just_pressed("crouch"):
		transition.emit("CrouchingPlayerState")
		
	if Input.is_action_pressed("sprint") and player.is_on_floor():
		transition.emit("SprintingPlayerState")
		
	player.update_movement()
	player.update_gravity(delta)
	player.update_velocity()
