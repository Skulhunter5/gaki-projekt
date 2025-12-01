class_name SprintingPlayerState extends PlayerMovementState

func enter() -> void:
	player.speed = player.sprinting_speed


func physics_update(delta : float) -> void:
	if player.velocity == Vector3.ZERO:
		transition.emit("IdlePlayerState")
	
	if player.velocity.y < -3.0 and not player.is_on_floor():
		transition.emit("FallingPlayerState")
	
	if Input.is_action_pressed("shoot"):
		weapon.shoot()
		transition.emit("WalkingPlayerState")
		
	player.update_movement()
	player.update_gravity(delta)
	player.update_velocity()


func handle_input(event: InputEvent):
	if event.is_action_pressed("crouch") or event.is_action_pressed("crouch_toggle"):
		transition.emit("CrouchingPlayerState")
		
	if event.is_action_released("sprint") or event.is_action_released("walk_forwards"): 
		transition.emit("WalkingPlayerState")
