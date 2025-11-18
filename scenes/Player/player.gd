extends CharacterBody3D

@export var speed = 5.0

@export var jump_velocity : float = 4.5
@export var tilt_limit = deg_to_rad(75)
@export_range(0.0,1.0) var mouse_sensitivity : float = 0.5
var paused : bool = true

@onready var _camera_pivot := $CameraPivot as Node3D
@onready var weapon := $CameraPivot/WeaponMount/Weapon as Node3D

var target_velocity: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
	if Input.is_action_pressed("shoot") and not paused:
		weapon.shoot()

	var input_dir := Input.get_vector("walk_left", "walk_right", "walk_forwards", "walk_backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		direction = direction.rotated(Vector3.UP, _camera_pivot.rotation.y)
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		paused = not paused
		if paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		
func _unhandled_input(event: InputEvent) -> void:
	if not paused and event is InputEventMouseMotion:
		_camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		_camera_pivot.rotation.y += -event.relative.x * mouse_sensitivity
