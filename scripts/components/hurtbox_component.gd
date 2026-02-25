class_name HurtboxComponent
extends Area3D

@onready var health_component: HealthComponent = $"../HealthComponent"

func _ready() -> void:
	area_entered.connect(on_hit)

func on_hit(hitbox: HitboxComponent):
	if hitbox == null:
		return
	
	hitbox.hit.emit(self)
	print(hitbox.damage)
	health_component.damage(hitbox.damage)
