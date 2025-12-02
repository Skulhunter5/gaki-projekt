class_name CrouchingPlayerState extends PlayerMovementState

@onready var crouch_shapecast : ShapeCast3D = $"../../CrouchShapeCast3D"

var _crouch_transition_speed : float = 4.0
var _want_uncrouch : float

func enter() -> void:
	player.speed = player.crouching_speed
	animation.play("crouch",-1.0, _crouch_transition_speed)
	_want_uncrouch = false


func physics_update(delta : float) -> void:
	if player.velocity.y < -3.0 and not player.is_on_floor():
		transition.emit("FallingPlayerState")
		
	if Input.is_action_pressed("shoot"):
		weapon.shoot()
		
	player.update_movement()
	player.update_gravity(delta)
	player.update_velocity()


func handle_input(event: InputEvent):
	if event.is_action_released("crouch"):
		_want_uncrouch = true
		uncrouch()
		
	if event.is_action_pressed("crouch_toggle"):
		_want_uncrouch = not _want_uncrouch
		uncrouch()
		
	if event.is_action_pressed("sprint") and Input.is_action_pressed("walk_forwards"):
		_want_uncrouch = not _want_uncrouch
		uncrouch()
		
	if event.is_action_pressed("reload"):
		weapon.reload()


func uncrouch():
	if not _want_uncrouch:
		return
	if not crouch_shapecast.is_colliding():
		animation.play("crouch", -1.0,-_crouch_transition_speed * 1.5, true)
		transition.emit("IdlePlayerState")
	elif crouch_shapecast.is_colliding():
		await get_tree().create_timer(0.1).timeout
		uncrouch()
