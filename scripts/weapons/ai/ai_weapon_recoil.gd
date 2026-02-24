extends Node3D

var current_rotation : Vector3
var target_rotation : Vector3

var current_position : Vector3
var target_position : Vector3

@onready var weapon := $WeaponController

func _ready() -> void:
	weapon.weapon_fired.connect(add_recoil)

func _process(delta: float) -> void:
	target_rotation = lerp(target_rotation, Vector3.ZERO, weapon.recoil_speed * delta)
	current_rotation = lerp(current_rotation, target_rotation, weapon.recoil_snap_amount * delta)
	basis = Quaternion.from_euler(current_rotation)
	
	target_position = lerp(target_position, Vector3.ZERO, weapon.recoil_speed * delta)
	current_position = lerp(current_position, target_position, weapon.recoil_snap_amount * delta)
	weapon.weapon_mesh.position = current_position


func add_recoil() -> void:
	target_rotation += Vector3(weapon.recoil_amount.x,
		randf_range(-weapon.recoil_amount.y, weapon.recoil_amount.y),
		randf_range(-weapon.recoil_amount.z, weapon.recoil_amount.z))
	target_position += Vector3(randf_range(0, 0),
		randf_range(0, 0),
		randf_range(weapon.recoil_amount.x / 10.0, weapon.recoil_amount.x * 2 / 10.0))
