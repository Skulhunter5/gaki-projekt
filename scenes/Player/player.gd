extends CharacterBody3D

@export var speed = 5.0

@export var jump_velocity : float = 4.5
@export var tilt_limit = deg_to_rad(75)
@export_range(0.0,1.0) var mouse_sensitivity : float = 0.5
# camera variables
var _mouse_input : bool = false
var _rotation_input : float
var _tilt_input : float
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3
var paused : bool = true

@onready var _camera_pivot := $CameraPivot as Node3D
#@onready var weapon := $CameraPivot/WeaponMount/Weapon as Node3D


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	_update_camera(delta)
		
#	if Input.is_action_pressed("shoot") and not paused:
#		weapon.shoot()

	var input_dir := Input.get_vector("walk_left", "walk_right", "walk_forwards", "walk_backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * _speed
		velocity.z = direction.z * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)
		velocity.z = move_toward(velocity.z, 0, _speed)

	move_and_slide()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		paused = not paused
		if paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		
func _unhandled_input(event: InputEvent) -> void:
	# handle looking around
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * mouse_sensitivity
		_tilt_input = -event.relative.y * mouse_sensitivity


func _update_camera(delta):
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clampf(_mouse_rotation.x, -tilt_limit, tilt_limit)
	_mouse_rotation.y += _rotation_input * delta
	
	#rotates player but only tilts camera, otherwise whole player will rotate up and down
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)
	
	# apply to camera
	_camera_pivot.transform.basis = Basis.from_euler(_camera_rotation)
	_camera_pivot.rotation.z = 0.0
	
	# apply to player
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	# reset otherwise infinite spinning (i guess)
	_rotation_input = 0.0
	_tilt_input = 0.0

