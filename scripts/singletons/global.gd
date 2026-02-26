extends Node

var debug

var weapons: Array[PackedScene] = [
	preload("res://scenes/Weapons/rework/Sniper.tscn"),
	preload("res://scenes/Weapons/rework/SubmachineGun.tscn"),
]
var selected_weapon: PackedScene = weapons[0]
var weapon_names: Array[String] = [
	"Sniper",
	"SMG",
]
