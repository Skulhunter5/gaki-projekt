class_name HurtboxComponent
extends Area3D

@onready var health_component: HealthComponent = $"../HealthComponent"

func _ready() -> void:
	area_entered.connect(on_hit)

func on_hit(hitbox: HitboxComponent):
	print("on_hit")
	
	if hitbox == null:
		return
	
	health_component.damage(hitbox.damage)
