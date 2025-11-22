class_name Player extends CharacterBody3D

@export var walking_speed : float = 5.0
@export var sprinting_speed : float = 7.0
@export var crouching_speed : float = 2.0
@export var acceleration : float = 0.1
@export var deceleration : float = 0.25
@export var jump_velocity : float = 4.5
@export var tilt_limit = deg_to_rad(75)
@export var animationplayer : AnimationPlayer
@export_range(1,100) var mouse_sensitivity : float = 5

# camera variables
var _mouse_input : bool = false
var _rotation_input : float
var _tilt_input : float
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3

var speed : float

@onready var _camera_pivot := $CameraPivot as Node3D
@onready var _crouch_shapecast := $CrouchShapeCast3D as ShapeCast3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# disables shapecast onto self but still allows cast for ceiliing objects
	_crouch_shapecast.add_exception($".")
	
	speed = walking_speed
	
func _process(delta: float) -> void:
	_update_camera(delta)

func _physics_process(_delta: float) -> void:
	
	Global.debug.add_property("MovementSpeed",speed,1)
	Global.debug.add_property("MouseRotation",_mouse_rotation,2)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().quit()


func _unhandled_input(event: InputEvent) -> void:
	# handle looking around
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.screen_relative.x * (mouse_sensitivity / 1000)
		_tilt_input = -event.screen_relative.y * (mouse_sensitivity / 1000)


func _update_camera(_delta):
	_mouse_rotation.x += _tilt_input
	_mouse_rotation.x = clampf(_mouse_rotation.x, -tilt_limit, tilt_limit)
	_mouse_rotation.y += _rotation_input
	
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


func update_movement():
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y += jump_velocity
	
	var input_dir := Input.get_vector("walk_left", "walk_right", "walk_forwards", "walk_backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x,direction.x * speed, acceleration)
		velocity.z = lerp(velocity.z,direction.z * speed, acceleration)
	else:
		var horizontal_vel = Vector3(velocity.x, 0, velocity.z)
		horizontal_vel = horizontal_vel.move_toward(Vector3.ZERO, deceleration)

		velocity.x = horizontal_vel.x
		velocity.z = horizontal_vel.z


func update_velocity():
	move_and_slide()


func update_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
