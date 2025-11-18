extends CharacterBody3D

@export var speed_default : float = 5.0
@export var speed_crouching : float = 2.0
@export var jump_velocity : float = 4.5
@export var tilt_limit = deg_to_rad(75)
#@export var toggled_crouch : bool = true
@export_range(1,100) var mouse_sensitivity : float = 5
@export_range(0.0,1.0) var _crouch_blend : float = 0.0
@export_range(1,100,1) var crouch_speed : float = 7.0

# camera variables
var _mouse_input : bool = false
var _rotation_input : float
var _tilt_input : float
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3

var _speed : float
var _is_crouching : bool = false

var paused : bool = true


@onready var _camera_pivot := $CameraPivot as Node3D
#@onready var _animation_player := $AnimationPlayer as AnimationPlayer
@onready var _anim_tree := $AnimationTree as AnimationTree
@onready var _crouch_shapecast := $CrouchShapeCast3D as ShapeCast3D
#@onready var weapon := $CameraPivot/WeaponMount/Weapon as Node3D

func _ready():
	# disables shapecast onto self but still allows cast for ceiliing objects
	_crouch_shapecast.add_exception($".")
	
	_speed = speed_default


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor() and not _is_crouching:
		velocity.y = jump_velocity
	
	_update_camera(delta)
		
#	if Input.is_action_pressed("shoot") and not paused:
#		weapon.shoot()

	# animation smoothing for crouching
	var _blend_target = 1.0 if _is_crouching else 0.0
	_crouch_blend = lerp(_crouch_blend, _blend_target, delta * crouch_speed)
	_anim_tree.set("parameters/_crouch_blend/blend_position", _crouch_blend)

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

	if event.is_action_pressed("crouch") and is_on_floor():
	#if event.is_action_pressed("crouch") and is_on_floor() and toggled_crouch:
		toggle_crouch()
#	if event.is_action_pressed("crouch",true)  and not toggled_crouch and not _is_crouching and is_on_floor():
#		crouching(true)
#	if event.is_action_released("crouch") and not toggled_crouch and _is_crouching:
#		if not _crouch_shapecast.is_colliding():
#			crouching(false)
#		elif _crouch_shapecast.is_colliding():
#			uncrouch_check()


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


func toggle_crouch():
	
	if _is_crouching and not _crouch_shapecast.is_colliding():
		set_movement_speed("default")
		_is_crouching = not _is_crouching
		#crouching(false)
	elif not _is_crouching:
		set_movement_speed("crouching")
		_is_crouching = not _is_crouching
		#crouching(true)
	


#func crouching(state: bool):
#	match state:
#		true:
#			_animation_player.play("crouch", -1, crouch_speed)
#			set_movement_speed("crouching")
#		false:
#			_animation_player.play("crouch", -1, -crouch_speed, true)
#			set_movement_speed("default")


#func uncrouch_check():
#	if not _crouch_shapecast.is_colliding():
#		crouching(false)
#	if _crouch_shapecast.is_colliding():
#		await get_tree().create_timer(0.1).timeout
#		uncrouch_check()


func set_movement_speed(state : String):
	match state:
		"default":
			_speed = speed_default
		"crouching":
			_speed = speed_crouching


func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "crouch":
		_is_crouching = not _is_crouching
