class_name HealthUI
extends VBoxContainer

@export var empty_color: Color
@export var full_color: Color

@export var health_component: HealthComponent

@onready var health_bar: ProgressBar = $HealthBar
@export var health_bar_color: StyleBoxFlat

func _ready() -> void:
	health_component.health_changed.connect(_on_health_change)
	health_bar.min_value = 0
	health_bar.max_value = health_component.MAX_HEALTH
	
	update_health_bar(health_component.health, health_component.MAX_HEALTH)

func update_health_bar(health: float, max_health: float) -> void:
	health_bar.value = health
	health_bar_color.bg_color = lerp(empty_color, full_color, health / max_health)

func _on_health_change(_old_health: float, new_health: float) -> void:
	update_health_bar(new_health, health_component.MAX_HEALTH)
