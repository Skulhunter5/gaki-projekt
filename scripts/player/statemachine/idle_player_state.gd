class_name IdlePlayerState extends PlayerMovementState

func enter() -> void:
	player.velocity = Vector3.ZERO


func physics_update(_delta : float):
	
	if Input.get_vector("walk_left", "walk_right", "walk_forwards", "walk_backwards") != Vector2.ZERO:
		transition.emit("WalkingPlayerState")


func handle_input(event: InputEvent):
	if event.is_action_pressed("crouch") or event.is_action_pressed("crouch_toggle"):
		transition.emit("CrouchingPlayerState")
