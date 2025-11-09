extends CharacterBody3D

@export var speed = 5.0
@export var jump_velocity = 15

@export var CAMERA: Camera3D
@export var MOUSE_SENSITIVITY: Vector2 = Vector2(0.02, 0.01)


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
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		paused = !paused
		if paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif !PAUSED and event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY.x)
		CAMERA.rotate_object_local(Vector3.MODEL_LEFT, -event.relative.y * MOUSE_SENSITIVITY.y)
		$WeaponMount.rotate_object_local(Vector3.MODEL_LEFT, -event.relative.y * MOUSE_SENSITIVITY.y)
