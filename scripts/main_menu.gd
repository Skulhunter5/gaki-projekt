class_name MainMenu
extends Control

@export var arena: PackedScene = preload("res://scenes/Arena.tscn")

@onready var weapon_list: ItemList = self.find_child("WeaponList")

func _ready() -> void:
	for weapon_name in Global.weapon_names:
		weapon_list.add_item(weapon_name)
	weapon_list.select(0)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(arena)


func _on_weapon_selected(index: int) -> void:
	Global.selected_weapon = Global.weapons[index]
