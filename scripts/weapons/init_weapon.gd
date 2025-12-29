class_name WeaponController extends Node3D

signal attack_primary_signal(weapon : WeaponController)

@export var weapon_type : Weapons # Weapon Resource

@onready var weapon_mesh : MeshInstance3D = $Weapon/WeaponMesh
@onready var fire_rate_timer := $Weapon/FireRateTimer
@onready var reload_timer := $Weapon/ReloadTimer
@onready var weapon := $Weapon

var max_ammo : int # max ammo defined by weapon
var max_magazine : int # max ammo that fits inside a magazine
var current_total_ammo : int # current total ammo - magazine
var current_magazine : int
var attack_range : int


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


func attack_primary():
	if fire_rate_timer.is_stopped() and current_magazine > 0 and reload_timer.is_stopped():
		attack_primary_signal.emit(self)
		current_magazine -= 1
		fire_rate_timer.start(1.0 / weapon_type.fire_rate)


func reload():
	if current_magazine < max_magazine and reload_timer.is_stopped():
		current_total_ammo += current_magazine
		current_magazine = 0
		reload_timer.start(weapon_type.reload_time)
		await reload_timer.timeout
		current_magazine += clamp(current_total_ammo,0,max_magazine)
		current_total_ammo -= current_magazine
