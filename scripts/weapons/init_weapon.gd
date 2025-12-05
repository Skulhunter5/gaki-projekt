@tool

class_name WeaponController extends Node3D
# Location of where bullets will fly from
@export var bullet_spawn : Node3D

@onready var weapon_mesh : MeshInstance3D = $Weapon/WeaponMesh
@onready var fire_rate_timer := $Weapon/FireRateTimer
@onready var reload_timer := $Weapon/ReloadTimer
@onready var weapon := $Weapon

var shooter : Node = null
var max_ammo : int # max ammo defined by weapon
var max_magazine : int # max ammo that fits inside a magazine
var current_total_ammo : int # current total ammo - magazine
var current_magazine : int
var bullet_scene = preload("res://scenes/Weapons/bullet.tscn")

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
	current_magazine = max_magazine
	current_total_ammo = max_ammo - max_magazine


func load_weapon():
	weapon_mesh.mesh = weapon_type.mesh
	weapon.position = weapon_type.position
	weapon.rotation_degrees = weapon_type.rotation
	weapon.scale = weapon_type.scale


func shoot():
	if fire_rate_timer.is_stopped() and current_magazine > 0 and reload_timer.is_stopped():
		current_magazine -= 1
		
		var bullet : RigidBody3D = bullet_scene.instantiate()
		if shooter:
			bullet.add_collision_exception_with(shooter)
		else: 
			push_warning("Shooter of weapon not set, collisions might behave wonky!")
		bullet.position = bullet_spawn.global_position
		bullet.rotation = owner._camera_rotation + owner._player_rotation
		get_tree().current_scene.add_child(bullet)
		
		var forward : Vector3 = -bullet.global_transform.basis.z
		bullet.linear_velocity = forward * weapon_type.bullet_range
		
		fire_rate_timer.start(1.0 / weapon_type.fire_rate)


func reload():
	if current_magazine < max_magazine and reload_timer.is_stopped():
		current_total_ammo += current_magazine
		current_magazine = 0
		reload_timer.start(weapon_type.reload_time)
		await reload_timer.timeout
		current_magazine += clamp(current_total_ammo,0,max_magazine)
		current_total_ammo -= current_magazine
