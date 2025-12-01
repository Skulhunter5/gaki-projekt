@tool

class_name WeaponController extends Node3D

@onready var fire_rate_timer := $FireRateTimer

@export var weapon_type : Weapons:
	set(value):
		weapon_type = value
		if Engine.is_editor_hint():
			load_weapon()

@onready var weapon_mesh : MeshInstance3D = $WeaponMesh

func _ready() -> void:
	load_weapon()


func load_weapon():
	weapon_mesh.mesh = weapon_type.mesh
	position = weapon_type.position
	rotation_degrees = weapon_type.rotation
	scale = weapon_type.scale


func shoot():
	if fire_rate_timer.is_stopped():
		print("shooting")
		fire_rate_timer.start(1.0 / weapon_type.fire_rate)
