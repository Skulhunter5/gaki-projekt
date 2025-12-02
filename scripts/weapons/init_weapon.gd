@tool

class_name WeaponController extends Node3D
# Location of where bullets will fly from
@export var bullet_spawn : Node3D

@onready var weapon_mesh : MeshInstance3D = $Weapon/WeaponMesh
@onready var fire_rate_timer := $Weapon/FireRateTimer
@onready var weapon := $Weapon

var max_ammo : int # max ammo defined by weapon
var max_magazine : int # max ammo that fits inside a magazine
var current_ammo : int = 0 # current total ammo - magazine
var max_ammo_array = Array([],TYPE_OBJECT,"Node",null) # used for object pooling -> instantiates all ammo at load in so reloading weapons wont cause hiccups -> might get deleted for simpler code if there is no need for pooling
var magazine_array = Array([],TYPE_OBJECT, "Node", null) # used for object pooling -> instantiated bullets from max_ammo_array which are loaded into the magazine -> maybe deprecated with the thing above
var used_ammo_array = Array([],TYPE_OBJECT, "Node", null) # used for object pooling -> instead of deleting bullets you they just get packed into a used array and taken back out if new ammo was gained -> also maybe deprecated 

# is used to get a life update in the editor when placing weapons etc.
@export var weapon_type : Weapons:
	set(value):
		weapon_type = value
		if Engine.is_editor_hint():
			load_weapon()

# reads the weapon resource and instantiates all bullets for object pooling
func _ready() -> void:
	load_weapon()
	max_ammo = weapon_type.max_ammo
	max_magazine = weapon_type.magazine_size

	var bullet_scene = preload("res://scenes/Weapons/bullet.tscn")
	for i in range(max_ammo):
		var bullet : RigidBody3D = bullet_scene.instantiate()
		max_ammo_array.append(bullet)
		current_ammo += 1
	for i in range(max_magazine):
		current_ammo -= 1
		
		var bullet : RigidBody3D = max_ammo_array.pop_back()
		magazine_array.append(bullet)
		get_tree().current_scene.add_child.call_deferred(bullet)
		bullet.freeze = true
		bullet.visible = false
		
		bullet.position = Vector3(0,1.5,-10)


func load_weapon():
	weapon_mesh.mesh = weapon_type.mesh
	weapon.position = weapon_type.position
	weapon.rotation_degrees = weapon_type.rotation
	weapon.scale = weapon_type.scale


func shoot():
	if fire_rate_timer.is_stopped() and magazine_array.size() != 0:
		print("shooting")
		print(owner.global_position)
		var bullet : RigidBody3D = magazine_array.pop_back()
		bullet.visible = true
		bullet.freeze = false
		bullet.global_position = bullet_spawn.global_position
		bullet.rotation = owner._camera_rotation + owner._player_rotation
		var forward : Vector3 = -bullet.global_transform.basis.z
		bullet.linear_velocity = forward * weapon_type.bullet_range
		used_ammo_array.append(bullet)
		print(bullet.linear_velocity)
		print("Current Magazine ", magazine_array.size())
		print("Current ammo:", current_ammo)
		fire_rate_timer.start(1.0 / weapon_type.fire_rate)


func reload():
	print("in reloading")
	while current_ammo > 0 and magazine_array.size() != max_magazine:
		print("in loop")
		current_ammo -= 1
		
		var bullet : RigidBody3D = max_ammo_array.pop_back()
		magazine_array.append(bullet)
		get_tree().current_scene.add_child(bullet)
		bullet.freeze = true
		bullet.visible = false
		
		bullet.position = Vector3(0,1.5,-10)
