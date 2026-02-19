class_name Arena
extends Node3D

var player = null
@export var player_scene: PackedScene
@export var enemy_scene: PackedScene

@export var player_spawn: Marker3D
@export var enemy_spawns: Array[Marker3D]

@export var wave_multiplier: int = 2
@export var wave_size: int = 1

#@export var number_of_spawns: int = 2

var no_enemys: int = 0
var current_enemys: int = 0
var current_spawn: int

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
	for enemy_spawn in enemy_spawns:
		for i in wave_size:
			var enemy := enemy_scene.instantiate() as Enemy
			enemy.player = player
			offset = Vector3(randf_range(-1.0, 1.0), 0, randf_range(-1.0, 1.0))
			add_child(enemy)
			current_enemys += 1
			enemy.global_position = enemy_spawn.global_position + offset
			
			enemy.died.connect(_on_enemy_death)

func new_wave():
	# Wave x2: 2, 4, 8, 16
	if current_enemys == no_enemys:
		#current_spawn = randi_range(1, number_of_spawns)
		wave_size *= 2
		spawn_enemies()

func _on_enemy_death() -> void:
	ScoreManager.add_score(10)
	current_enemys -= 1
	new_wave()

func _on_player_death() -> void:
	ScoreManager.end_round()
