extends CharacterBody3D

@export var speed = 5.0
@export var jump_velocity = 15
@export var fall_acceleration = 50

@export var tilt_limit = deg_to_rad(75)
@export_range(0.0,1.0) var mouse_sensitivity = 0.01

@onready var _camera_pivot := $CameraPivot as Node3D
@onready var weapon := $CameraPivot/WeaponMount/Weapon as Node3D

var target_velocity: Vector3 = Vector3.ZERO
var paused: bool = true

func _physics_process(delta: float) -> void:
	var direction: Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("shoot") and not paused:
		weapon.shoot()
	
	if Input.is_action_pressed("walk_forwards"):
		direction.z -= 1
	if Input.is_action_pressed("walk_backwards"):
		direction.z += 1
	if Input.is_action_pressed("walk_left"):
		direction.x -= 1
	if Input.is_action_pressed("walk_right"):
		direction.x += 1
	if Input.is_action_pressed("jump"):
		target_velocity.y = jump_velocity
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
	direction = direction.rotated(Vector3.UP, _camera_pivot.rotation.y)
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		
	velocity = target_velocity
	move_and_slide()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		paused = !paused
		if paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		
func _unhandled_input(event: InputEvent) -> void:
	if not paused and event is InputEventMouseMotion:
		_camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		_camera_pivot.rotation.y += -event.relative.x * mouse_sensitivity
