class_name NewWeaponController extends Node3D

@export var weapon : WeaponBase

func _ready() -> void:
	if self.get_child_count() > 0:
		weapon = self.get_child(0)


func attack_primary():
	if weapon:
		weapon.attack_primary()


func attack_secondary():
	if weapon:
		weapon.attack_secondary()


func reload():
	if weapon:
		weapon.reload()
