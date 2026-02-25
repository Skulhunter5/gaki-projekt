class_name JumpingPlayerState extends PlayerMovementState

signal weapon_reloaded
signal weapon_primary_attacked
signal weapon_secondary_attacked

func enter() -> void:
	player.velocity.y = player.jump_height


func exit() -> void:
	pass


func update(delta : float) -> void:
	
	if player.velocity.y < 0.0:
		transition.emit("FallingPlayerState")
		
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
