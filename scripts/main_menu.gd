extends Control

@export var arena: PackedScene = preload("res://scenes/Arena.tscn")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(arena)
