class_name TestWeapon
extends Weapon

@export var MUZZLE_VELOCITY: float = 0.5
@export var FIRE_RATE: float = 1

@onready var MUZZLE: Marker3D = $Muzzle
@onready var TIMER: Timer = $Timer

func _ready():
	TIMER.one_shot = true

var BULLET_PREFAB: PackedScene = preload("res://scenes/Weapons/Bullet.tscn")

func shoot():
	if TIMER.time_left == 0:
		var bullet := BULLET_PREFAB.instantiate() as Node3D
		bullet.transform = MUZZLE.global_transform
		bullet.velocity = MUZZLE_VELOCITY
		get_tree().root.add_child(bullet)
		TIMER.start(1 / FIRE_RATE)
