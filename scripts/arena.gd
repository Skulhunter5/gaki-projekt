class_name Arena
extends Node3D

var player = null
@export var player_scene: PackedScene
@export var enemy_scene: PackedScene

@export var player_spawn: Marker3D
@export var enemy_spawns: Array[Marker3D]

var wave_size: int = 1

#@export var number_of_spawns: int = 2

var no_enemys: int = 0
var current_enemys: int = 0

func _ready() -> void:
	spawn_player()
	spawn_enemies()
	ScoreManager.start_round()

func spawn_player():
	player = player_scene.instantiate() as Player
	add_child(player)
	player.global_position = player_spawn.global_position

	player.died.connect(_on_player_death)

func spawn_enemies():
	var offset: Vector3
	var spawns = 0
	for enemy_spawn in enemy_spawns:
		for i in wave_size:
			var enemy := enemy_scene.instantiate() as Enemy
			enemy.player = player
			
			if(spawns == 0):
				enemy.waypoints.append($Waypoints/WP1_1)
				enemy.waypoints.append($Waypoints/WP1_2)
				enemy.waypoints.append($Waypoints/WP1_3)
			if(spawns == 1):
				enemy.waypoints.append($Waypoints/WP2_1)
				enemy.waypoints.append($Waypoints/WP2_2)
			if(spawns == 2):
				enemy.waypoints.append($Waypoints/WP3_1)
				enemy.waypoints.append($Waypoints/WP3_2)
			if(spawns == 3):
				enemy.waypoints.append($Waypoints/WP4_1)
				enemy.waypoints.append($Waypoints/WP4_2)
				
			offset = Vector3(randf_range(-2.0, 2.0), 0, randf_range(-2.0, 2.0))
			add_child(enemy)
			current_enemys += 1
			enemy.global_position = enemy_spawn.global_position + offset
			
			enemy.died.connect(_on_enemy_death)
		spawns += 1

func new_wave():
	if current_enemys == no_enemys:
		wave_size += 1
		spawn_enemies()

func _on_enemy_death() -> void:
	ScoreManager.add_score(10)
	current_enemys -= 1
	new_wave()

func _on_player_death() -> void:
	ScoreManager.end_round()
