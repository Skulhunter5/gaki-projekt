extends CharacterBody3D

@export var speed = 5.0
@export var jump_velocity = 15

@export var tilt_limit = deg_to_rad(75)
@export_range(0.0,1.0) var mouse_sensitivity = 0.01

@onready var _camera_pivot := $CameraPivot as Node3D
@onready var weapon := $CameraPivot/WeaponMount/Weapon as Node3D

func _physics_process(_delta: float) -> void:
	var left_right := Input.get_axis("walk_left", "walk_right")
	var forwards_backwards := Input.get_axis("walk_forwards", "walk_backwards")
	var movement = Vector3.MODEL_FRONT * forwards_backwards + Vector3.MODEL_LEFT * left_right
	if movement.length_squared() > 1.0:
		movement = movement.normalized()
	movement *= SPEED
	velocity = movement
var paused: bool = true
	
	if Input.is_action_pressed("shoot"):
		$WeaponMount/Weapon.shoot()
	direction = direction.rotated(Vector3.UP, _camera_pivot.rotation.y)
	
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
