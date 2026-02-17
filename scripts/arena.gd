class_name Arena
extends Node3D

@export var player_scene: PackedScene
@export var enemy_scene: PackedScene

@export var player_spawn: Marker3D
@export var enemy_spawns: Array[Marker3D]

@export var wave_multiplier: int = 2
@export var wave_size: int = 1 #0

func _ready() -> void:
	spawn_player()
	spawn_enemies()
	ScoreManager.start_round()

func spawn_player():
	var player := player_scene.instantiate() as Player
	add_child(player)
	player.global_position = player_spawn.global_position

	player.died.connect(_on_player_death)

func spawn_enemies():
	for enemy_spawn in enemy_spawns:
		for i in wave_size:
			var enemy := enemy_scene.instantiate() as Enemy
			add_child(enemy)
			enemy.global_position = enemy_spawn.global_position

			enemy.died.connect(_on_enemy_death)

func new_wave():
	# Wave x2: 2, 4, 8, 16
	if ScoreManager.score == (2 * (wave_size) * 10):
		wave_size = wave_size * wave_multiplier
		spawn_enemies()

func _on_enemy_death() -> void:
	ScoreManager.add_score(10)
	new_wave()

func _on_player_death() -> void:
	ScoreManager.end_round()
