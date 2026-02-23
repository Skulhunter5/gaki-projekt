class_name WeaponBase extends Node3D

@warning_ignore("unused_signal")
signal primary_attacked
@warning_ignore("unused_signal")
signal secondary_attacked
@warning_ignore("unused_signal")
signal ammo_changed(magazine: int, max_magazine: int, total: int, max_total: int)
@warning_ignore("unused_signal")
signal bullet_spawned(bullet : RigidBody3D)

func _initialize() -> void:
	pass


func attack_primary():
	pass


func attack_secondary():
	pass


func reload():
	pass
