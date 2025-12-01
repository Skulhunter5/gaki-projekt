class_name IdlePlayerState extends PlayerMovementState

func enter() -> void:
	player.velocity = Vector3.ZERO


func update(delta : float):
	if Input.get_vector("walk_left", "walk_right", "walk_forwards", "walk_backwards") != Vector2.ZERO:
		transition.emit("WalkingPlayerState")
	
	if player.velocity.y < -3.0 and not player.is_on_floor():
		transition.emit("FallingPlayerState")

	player.update_gravity(delta)
	player.update_velocity()	


func handle_input(event: InputEvent):
	if event.is_action_pressed("crouch") or event.is_action_pressed("crouch_toggle"):
		transition.emit("CrouchingPlayerState")
	
