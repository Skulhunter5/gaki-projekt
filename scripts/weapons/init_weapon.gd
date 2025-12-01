@tool

extends Node3D

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
