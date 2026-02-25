class_name Enemy
extends CharacterBody3D

signal died()

var player = null
var fov = 100

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var patrol_index := 0

#Timers
var patrol_timer := 0.0
var search_timer := 0.0
var update_timer := 0.0

# Save the positions for returnpoint and searchpoint
var search_position: Vector3
var return_position: Vector3 

@export var player_path : NodePath

@export var speed = 2.0
@export var damage = 5
# Distance where enemy can hear the player
@export var hearing_range = 4
# Distance where enemy can shoot at player
@export var engagement_distance = 2#250
# Waypoints for patrol
# Waypoints need to be added to the World scene
# Use Node3D
@export var waypoints: Array[Node3D] = []
# Time to wait after each waypoint and time searching
@export var search_wait_time = 4.0
@export var patrol_wait_time = 3.0

# Interval for updating the navigation target
@export var update_interval = 0.2

@onready var nav_agent = $NavigationAgent3D
#@onready var coll_shape = $CollisionShape3D
@onready var raycast = $RayCast3D
@onready var state_machine := $EnemyStateMachine


func _ready() -> void:
	if !player_path.is_empty():
		player = get_node(player_path)
	return_position = global_transform.origin
	return_position.y += 2
	
	$HitboxComponent.damage = damage


func _physics_process(delta: float) -> void:

	apply_gravity(delta)
	looking()
	move_and_slide()


func player_in_hearing_range():
	return global_position.distance_to(player.global_position) < hearing_range


func player_in_sight() -> bool:
	return player and raycast.is_colliding() and raycast.get_collider() == player


func looking() -> void:
	if not player:
		return
 
	var to_player = (player.global_transform.origin - global_transform.origin).normalized()
	var forward = -global_transform.basis.z
	var angle_deg = rad_to_deg(acos(clamp(forward.dot(to_player), -1.0, 1.0)))
	if angle_deg > fov * 0.5:
		return
 
	var ray_forward = -raycast.global_transform.basis.z
	var new_dir = ray_forward.slerp(to_player, 0.2).normalized()
	raycast.look_at(raycast.global_transform.origin + new_dir, Vector3.UP)


func next_waypoint() -> void:
		patrol_index = ( patrol_index + 1) % waypoints.size()
		nav_agent.set_target_position(waypoints[patrol_index].global_transform.origin)


func go_to(next_position: Vector3) -> void:
	var dir_to_next_position = (next_position - global_transform.origin)
	dir_to_next_position.y = 0.0
	# when point is reached, stop
	if is_zero_approx( dir_to_next_position.length()):
		velocity.x = lerp(velocity.x, 0.0, 0.2)
		velocity.z = lerp(velocity.z, 0.0, 0.2)
		return
	
	dir_to_next_position = dir_to_next_position.normalized()
	var current_dir = -global_transform.basis.z
	var new_dir = current_dir.slerp(dir_to_next_position, 0.12).normalized()
	look_at(global_transform.origin + new_dir, Vector3.UP)
	
	velocity.x = dir_to_next_position.x * speed
	velocity.z = dir_to_next_position.z * speed


func _on_death() -> void:
	state_machine.on_child_transition("DeadEnemyState")
	died.emit()
	queue_free()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0
