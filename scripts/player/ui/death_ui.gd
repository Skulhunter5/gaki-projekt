class_name DeathUI
extends VBoxContainer

@export var reticle: Control

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_player_death() -> void:
	visible = true
	reticle.visible = false
