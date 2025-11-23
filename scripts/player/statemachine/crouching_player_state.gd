class_name CrouchingPlayerState extends PlayerMovementState

@onready var crouch_shapecast : ShapeCast3D = $"../../CrouchShapeCast3D"

var crouch_transition_speed : float = 4.0


func enter() -> void:
	player.speed = player.crouching_speed
	animation.play("crouch",-1.0, crouch_transition_speed)


func physics_update(delta : float) -> void:
	player.update_gravity(delta)
	player.update_movement()
	player.update_velocity()


func handle_input(event: InputEvent):
	if event.is_action_released("crouch") or event.is_action_pressed("crouch_toggle"):
		uncrouch()


func uncrouch():
	if not crouch_shapecast.is_colliding():
		animation.play("crouch", -1.0,-crouch_transition_speed * 1.5, true)
		transition.emit("IdlePlayerState")
	elif crouch_shapecast.is_colliding():
		return
