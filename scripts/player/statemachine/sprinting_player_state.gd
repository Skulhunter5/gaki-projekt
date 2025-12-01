class_name SprintingPlayerState extends PlayerMovementState

func enter() -> void:
	player.speed = player.sprinting_speed


func physics_update(delta : float) -> void:
	player.update_gravity(delta)
	player.update_movement()
	player.update_velocity()

	if player.velocity == Vector3.ZERO:
		transition.emit("IdlePlayerState")


func handle_input(event: InputEvent):
	if event.is_action_pressed("crouch") or event.is_action_pressed("crouch_toggle"):
		transition.emit("CrouchingPlayerState")
		
	if event.is_action_released("sprint"): 
		transition.emit("WalkingPlayerState")
