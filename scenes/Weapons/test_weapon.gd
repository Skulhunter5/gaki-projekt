class_name TestWeapon
extends Weapon

@export var muzzle_velocity: float = 0.5
@export var fire_rate: float = 1

@onready var muzzle: Marker3D = $Muzzle
@onready var timer: Timer = $Timer

func _ready():
	timer.one_shot = true

var bullet_prefab: PackedScene = preload("res://scenes/Weapons/Bullet.tscn")

func shoot():
	if timer.time_left == 0:
		var bullet := bullet_prefab.instantiate() as Node3D
		bullet.transform = muzzle.global_transform
		bullet.velocity = muzzle_velocity
		get_tree().root.add_child(bullet)
		timer.start(1 / fire_rate)
