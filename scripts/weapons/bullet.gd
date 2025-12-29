extends RigidBody3D

var impact_scene := preload("res://scenes/Weapons/impact_effect.tscn")
@onready var ray_cast = $RayCast3D

func _physics_process(_delta: float) -> void:
	if ray_cast.is_colliding():
		var contact_pos = ray_cast.get_collision_point()
		var contact_normal = ray_cast.get_collision_normal()
		spawn_impact(contact_pos,contact_normal)


func _on_body_entered(_body: Node) -> void:
	queue_free()


func spawn_impact(pos: Vector3, normal: Vector3):
	var impact = impact_scene.instantiate()
	get_tree().current_scene.add_child(impact)
	impact.global_position = pos
	
	# no idea why but it turns them right
	impact.quaternion = Quaternion(Vector3.UP,normal)
