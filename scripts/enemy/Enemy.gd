extends CharacterBody3D

var player = null
var health = 100
var state

enum {
	Idle,
	Follow,
	Attack,
	Dead
}

@export var player_path : NodePath
@export var speed = 2.0
@export var damage = 200
@export var hearing_range = 4

@onready var nav_agent = $NavigationAgent3D
@onready var coll_shape = $CollisionShape3D
@onready var raycast = $RayCast3D


func _ready() -> void:
	player = get_node(player_path)
	state = Idle


func _physics_process(delta: float) -> void:

	match state:
		Idle:
			raycast.look_at(player.global_position, Vector3.UP)
			if player_in_sight():
				state = Follow
			if(player_in_hearing_range()):
				state = Follow

		Follow:
			velocity = Vector3.ZERO
			
			nav_agent.set_target_position(player.global_position)
			var next_nav_point = nav_agent.get_next_path_position()
			#look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
			if !player_in_sight():
				state = Idle
			velocity = (next_nav_point - global_position).normalized() * speed
			
			move_and_slide()
			

		Attack:
			pass

		Dead:
			pass


func player_in_hearing_range():
	return global_position.distance_to(player.global_position) < hearing_range


func player_in_sight():
	if raycast.is_colliding():
		if raycast.get_collider() == player:
			return true
