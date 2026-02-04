class_name AI_WeaponController extends Node3D

signal bullet_spawned(bullet : RigidBody3D)
signal weapon_fired
signal ammo_changed(magazine: int, max_magazine: int, total: int, max_total: int)

@export var weapon_type : Weapons # Weapon Resource

@onready var weapon_mesh := $Weapon/WeaponMesh
@onready var weapon_muzzle_flash := $Weapon/MuzzleFlash
@onready var fire_rate_timer := $Weapon/FireRateTimer
@onready var reload_timer := $Weapon/ReloadTimer
@onready var weapon := $Weapon
@onready var bullet_spawn := $BulletSpawn

var bullet_scene = preload("res://scenes/Weapons/bullet.tscn")

var max_ammo : int # max ammo defined by weapon
var max_magazine : int # max ammo that fits inside a magazine
var current_total_ammo : int # current total ammo - magazine
var current_magazine : int
var attack_range : int
var reload_time : float
var recoil_amount : Vector3
var recoil_snap_amount : float
var recoil_speed : float


# reads the weapon resource and instantiates all bullets for object pooling
func _ready() -> void:
	
	#Node based properties
	weapon_mesh.mesh = weapon_type.mesh
	weapon.position = weapon_type.position
	weapon.rotation_degrees = weapon_type.rotation
	weapon.scale = weapon_type.scale
	
	# custom weapon based properties
	max_ammo = weapon_type.max_ammo
	max_magazine = weapon_type.magazine_size
	current_magazine = max_magazine
	current_total_ammo = max_ammo - max_magazine
	attack_range = weapon_type.bullet_range
	reload_time = weapon_type.reload_time
	recoil_amount = weapon_type.recoil_amount
	recoil_snap_amount = weapon_type.recoil_snap_amount
	recoil_speed = weapon_type.recoil_speed
	
	ammo_changed.emit(current_magazine, max_magazine, current_total_ammo, max_ammo)


func attack_primary():
	if fire_rate_timer.is_stopped() and current_magazine > 0 and reload_timer.is_stopped():
		weapon_fired.emit()
		weapon_muzzle_flash.add_muzzle_flash()
		spawn_bullet()
		current_magazine -= 1
		fire_rate_timer.start(1.0 / weapon_type.fire_rate)
		ammo_changed.emit(current_magazine, max_magazine, current_total_ammo, max_ammo)


func reload():
	if current_magazine < max_magazine and reload_timer.is_stopped():
		current_total_ammo += current_magazine
		current_magazine = 0
		reload_timer.start(reload_time)
		await reload_timer.timeout
		current_magazine += clamp(current_total_ammo,0,max_magazine)
		current_total_ammo -= current_magazine
		ammo_changed.emit(current_magazine, max_magazine, current_total_ammo, max_ammo)


func spawn_bullet() -> void:
	var bullet : RigidBody3D = bullet_scene.instantiate()
	
	bullet_spawned.emit(bullet)
	
	bullet.position = bullet_spawn.global_position
	#bullet.rotation = owner._camera_rotation + owner._player_rotation
	get_tree().current_scene.add_child(bullet)
	
	var forward : Vector3 = -bullet.global_transform.basis.z
	bullet.linear_velocity = forward * attack_range
