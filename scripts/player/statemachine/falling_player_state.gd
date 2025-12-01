class_name FallingPlayerState extends PlayerMovementState

func enter() -> void:
	pass


func exit() -> void:
	pass


func update(delta : float) -> void:
	player.update_gravity(delta)
	player.update_movement()
	player.update_velocity()
	
	if player.is_on_floor():
		transition.emit("IdlePlayerState")
