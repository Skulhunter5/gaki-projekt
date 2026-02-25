class_name FallingPlayerState extends PlayerMovementState

signal weapon_reloaded
signal weapon_primary_attacked
signal weapon_secondary_attacked

func enter() -> void:
	pass


func exit() -> void:
	pass


func update(delta : float) -> void:
	
	if player.is_on_floor():
		if Input.get_vector("walk_left", "walk_right", "walk_forwards", "walk_backwards") != Vector2.ZERO:
			transition.emit("WalkingPlayerState")
		else:
			transition.emit("IdlePlayerState")
	
	if Input.is_action_pressed("primary_attack"):
		weapon_primary_attacked.emit()
		
	player.update_gravity(delta)
	player.update_movement()
	player.update_velocity()


func handle_input(event: InputEvent):
	if event.is_action_pressed("reload"):
		weapon_reloaded.emit()
		
		
	if event.is_action_pressed("secondary_attack"):
		weapon_secondary_attacked.emit()
