class_name SprintingPlayerState extends PlayerMovementState

func enter() -> void:
	player._speed = player.sprinting_speed


func physics_update(delta : float) -> void:
	if Input.is_action_just_released("sprint"):
		transition.emit("WalkingPlayerState")

	player.update_gravity(delta)
	player.update_movement()
	player.update_velocity()
