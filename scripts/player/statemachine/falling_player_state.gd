class_name FallingPlayerState extends PlayerMovementState

func enter() -> void:
	pass


func exit() -> void:
	pass


func update(delta : float) -> void:
	if Input.is_action_pressed("shoot"):
		weapon.shoot()
	
	if player.is_on_floor():
		transition.emit("IdlePlayerState")
		
	player.update_gravity(delta)
	player.update_movement()
	player.update_velocity()


func handle_input(event: InputEvent):
	if event.is_action_pressed("reload"):
		weapon.reload()
