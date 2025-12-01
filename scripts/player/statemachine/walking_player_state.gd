class_name WalkingPlayerState extends PlayerMovementState

func enter() -> void:
	player.speed = player.walking_speed	

func physics_update(delta : float):
	if player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")
		
	player.update_movement()
	player.update_gravity(delta)
	player.update_velocity()


func handle_input(event: InputEvent):
	if event.is_action_pressed("crouch") or event.is_action_pressed("crouch_toggle"):
		transition.emit("CrouchingPlayerState")
		
	if event.is_action_pressed("sprint") and player.is_on_floor():
		transition.emit("SprintingPlayerState")
