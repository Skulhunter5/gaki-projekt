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
	
	if Input.is_action_just_released("crouch"):
		uncrouch()


func uncrouch():
	if not crouch_shapecast.is_colliding():
		animation.play("crouch", -1.0,-crouch_transition_speed * 1.5, true)
		transition.emit("IdlePlayerState")
	elif crouch_shapecast.is_colliding():
		await get_tree().create_timer(0.1).timeout
		uncrouch()
