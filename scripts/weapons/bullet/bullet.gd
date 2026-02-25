class_name Bullet
extends RigidBody3D

var impact_scene := preload("res://scenes/Weapons/BulletImpact.tscn")
@onready var ray_cast = $RayCast3D
@onready var hitbox: HitboxComponent = $HitboxComponent

var last_position: Vector3

func _ready() -> void:
	body_entered.connect(_on_bullet_hit)
	
	last_position = global_position

func _physics_process(_delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(last_position, global_position)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = 256
	
	var result = space_state.intersect_ray(query)
	
	if result:
		if is_instance_of(result.collider, HurtboxComponent):
			var hurtbox: HurtboxComponent = result.collider
			hurtbox.on_hit(hitbox)
	
	last_position = global_position
	
	if ray_cast.is_colliding():
		
		var contact_pos = ray_cast.get_collision_point()
		var contact_normal = ray_cast.get_collision_normal()
		var collider = ray_cast.get_collider()
		_on_bullet_hit(collider)
		spawn_impact(contact_pos,contact_normal)


func spawn_impact(pos: Vector3, normal: Vector3):
	var impact = impact_scene.instantiate()
	get_tree().current_scene.add_child(impact)
	impact.global_position = pos
	
	# no idea why but it turns them right
	impact.quaternion = Quaternion(Vector3.UP,normal)


func _on_bullet_hit(_body: Node3D) -> void:
	queue_free()

func _on_hitbox_hit(_hurtbox: HurtboxComponent) -> void:
	queue_free()
