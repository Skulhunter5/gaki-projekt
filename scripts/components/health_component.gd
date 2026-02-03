class_name HealthComponent
extends Node

@export var MAX_HEALTH: int = 1

signal health_changed(old_health: float, new_health: float)
signal died()

var has_died: bool = false
var health: float = 0

func _ready() -> void:
	health = MAX_HEALTH

func damage(amount: float) -> bool:
	if has_died:
		return false
	
	var old_health = health
	health = max(health - amount, 0)
	
	if old_health != health:
		health_changed.emit(old_health, health)
	if health <= 0:
		has_died = true
		died.emit()
	
	return true

func heal(amount: float) -> bool:
	if has_died:
		return false
	
	var old_health = health
	health = min(health + amount, MAX_HEALTH)
	
	if old_health != health:
		health_changed.emit(old_health, health)
	
	return true
