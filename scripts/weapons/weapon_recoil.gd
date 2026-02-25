extends Node3D

var current_rotation : Vector3
var target_rotation : Vector3

var current_position : Vector3
var target_position : Vector3

@export var weapon_controller : NewWeaponController
var weapon : WeaponBase

func _ready() -> void:
	if weapon_controller.get_child(0):
		weapon = weapon_controller.get_child(0) as WeaponBase
		weapon.primary_attacked.connect(add_recoil)


func _process(delta: float) -> void:
	if weapon: 
		target_rotation = lerp(target_rotation, Vector3.ZERO, weapon.recoil_speed * delta)
		current_rotation = lerp(current_rotation, target_rotation, weapon.recoil_snap_amount * delta)
		basis = Quaternion.from_euler(current_rotation)
		
		target_position = lerp(target_position, Vector3.ZERO, weapon.recoil_speed * delta)
		current_position = lerp(current_position, target_position, weapon.recoil_snap_amount * delta)
		weapon.mesh.position = current_position
		
		weapon.current_rotation = current_rotation

func add_recoil() -> void:
	target_rotation += Vector3(weapon.recoil_amount.x,
		randf_range(-weapon.recoil_amount.y, weapon.recoil_amount.y),
		randf_range(-weapon.recoil_amount.z, weapon.recoil_amount.z))
	target_position += Vector3(randf_range(0, 0),
		randf_range(0, 0),
		clampf(randf_range(weapon.recoil_amount.x / 10.0, weapon.recoil_amount.x * 2 / 10.0),0,0.005))
