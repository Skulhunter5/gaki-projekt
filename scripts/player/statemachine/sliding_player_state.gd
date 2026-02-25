class_name SlidingPlayerState extends PlayerMovementState

signal weapon_primary_attacked
signal weapon_secondary_attacked
signal weapon_reloaded

@export var speed := 6.0 
@export var slide_anim_speed := 4.0

func enter() -> void:
	player.animationplayer.get_animation("Sliding").track_set_key_value(4,0,player.velocity.length())
	player.animationplayer.speed_scale = 1.0
	player.animationplayer.play("Sliding", -1.0, slide_anim_speed)

func update(delta) -> void:
	
	if player.velocity.y < -3.0 and not player.is_on_floor():
		transition.emit("FallingPlayerState")
	
	if Input.is_action_pressed("primary_attack"):
		weapon_primary_attacked.emit()


	player.update_gravity(delta)
	player.update_velocity()


func finish():
	if $"../../CrouchShapeCast3D".is_colliding():
		$"..".current_state = $"..".states.get("CrouchingPlayerState")
		$"../..".speed = $"../..".crouching_speed
	else:
		player.animationplayer.on_animation_played("crouch", -1.0,-4.0 * 1.5, true)
		transition.emit("IdlePlayerState")


func handle_input(event: InputEvent):
	if event.is_action_pressed("reload"):
		weapon_reloaded.emit()

	if event.is_action_pressed("secondary_attack"):
		weapon_secondary_attacked.emit()
		
	if event.is_action_pressed("crouch") or event.is_action_pressed("crouch_toggle"):
		transition.emit("WalkingPlayerState")
		player.animationplayer.pause()
		player.animationplayer.on_animation_played("crouch", -1.0,-4.0 * 1.5, true)
	
	if event.is_action_pressed("jump"):
		transition.emit("JumpingPlayerState")
		player.animationplayer.pause()
		player.animationplayer.on_animation_played("crouch", -1.0,-4.0 * 1.5, true)
		
