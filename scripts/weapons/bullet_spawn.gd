extends Node3D

signal collision_exception_signal(bullet : RigidBody3D)

var bullet_scene = preload("res://scenes/Weapons/bullet.tscn")

func _on_weapon_controller_primary_attacked(weapon : WeaponController) -> void:
	var bullet : RigidBody3D = bullet_scene.instantiate()
	
	collision_exception_signal.emit(bullet)
	
	bullet.position = global_position
	bullet.rotation = owner._camera_rotation + owner._player_rotation
	get_tree().current_scene.add_child(bullet)
	
	var forward : Vector3 = -bullet.global_transform.basis.z
	bullet.linear_velocity = forward * weapon.attack_range
