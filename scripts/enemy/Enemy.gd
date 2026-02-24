class_name Enemy
extends CharacterBody3D

signal died()

var player = null
var health = 100
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

# States
enum States {
	IDLE,
	PATROL,
	FOLLOW,
	SEARCH,
	SHOOT,
	RETURN,
	DEAD
}
var state: States = States.IDLE

@export var player_path : NodePath

@export var speed = 2.0
@export var damage = 200
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




func _ready() -> void:
	if !player_path.is_empty():
		player = get_node(player_path)
	return_position = global_transform.origin
	return_position.y = 2
	enter_new_state(States.IDLE if waypoints.is_empty() else States.PATROL)
	
	$HitboxComponent.damage = damage


func _physics_process(delta: float) -> void:

	update_path(delta)
	
	match state:
		States.IDLE: idle_state()
		States.PATROL: patrol_state(delta)
		States.FOLLOW: follow_state(delta)
		States.RETURN: return_state(delta)
		States.SEARCH: search_state(delta)
		States.SHOOT: shoot_state()
		States.DEAD:
			pass
		#States.FOLLOW:
		#	velocity = Vector3.ZERO
			
		#	nav_agent.set_target_position(player.global_position)
		#	var next_nav_point = nav_agent.get_next_path_position()
			#look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		#	if !player_in_sight():
		#		state = States.IDLE
		#	velocity = (next_nav_point - global_position).normalized() * speed
			
		#	move_and_slide()
	apply_gravity(delta)
	looking()
	move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0
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

# Set new navigation target
func new_nav_agent_target() -> void:
	match state:
			States.PATROL:
				if waypoints.size() > 0:
					nav_agent.set_target_position(waypoints[patrol_index].global_transform.origin)
			States.SEARCH:
				nav_agent.set_target_position(search_position)
			States.FOLLOW:
				if player:
					nav_agent.set_target_position(player.global_transform.origin)
			States.RETURN:
				nav_agent.set_target_position(return_position)

func update_path(delta):
	update_timer -= delta
	if update_timer <= 0.0:
		new_nav_agent_target()
		update_timer = update_interval

func enter_new_state(new_state: States) -> void:
	state = new_state
	match state:
		States.PATROL:
			patrol_timer = 0
			next_waypoint()
		States.SEARCH:
			search_timer = 0.0
			nav_agent.set_target_position(search_position)
		States.FOLLOW, States.SEARCH:
			return_position = global_transform.origin
		States.RETURN:
			nav_agent.set_target_position(return_position)






# State functions



func idle_state() -> void:
	velocity = Vector3.ZERO
	nav_agent.set_target_position(global_position)
	if player_in_sight():# or player_in_hearing_range():
		enter_new_state(States.FOLLOW)

func follow_state(_delta: float) -> void:
	if not player:
		enter_new_state(States.RETURN)
		return
	
	go_to(nav_agent.get_next_path_position())
	
	if global_transform.origin.distance_to(player.global_transform.origin) < engagement_distance:
		enter_new_state(States.SHOOT)
	elif not player_in_sight():
		search_position = player.global_transform.origin
		search_position.y = 2
		enter_new_state(States.SEARCH)

func patrol_state(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		if patrol_timer <= 0.0:
			patrol_timer = patrol_wait_time
			velocity = Vector3.ZERO
		else:
			patrol_timer -= delta
			if patrol_timer <= 0.0:
				next_waypoint()
	else:
		go_to(nav_agent.get_next_path_position())
		
	if player_in_sight():
		enter_new_state(States.FOLLOW)


func return_state(delta: float) -> void:
	if waypoints.is_empty():
		if nav_agent.is_navigation_finished():
			enter_new_state(States.IDLE)
		else:
			go_to(nav_agent.get_next_path_position())
		return
	if nav_agent.is_navigation_finished() and not waypoints.is_empty():
		enter_new_state(States.PATROL)
	elif player_in_sight():
		enter_new_state(States.FOLLOW)
	else:
		go_to(nav_agent.get_next_path_position())

func search_state(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		if search_timer <= 0.0:
			search_timer = search_wait_time
			velocity = Vector3.ZERO
		else:
			search_timer -= delta
			if search_timer <= 0.0:
				enter_new_state(States.RETURN)
	else:
		go_to(nav_agent.get_next_path_position())
	
	if player_in_sight():
		enter_new_state(States.FOLLOW)

func shoot_state() -> void:
	velocity = Vector3.ZERO
	# TODO
	enter_new_state(States.FOLLOW)

func _on_death() -> void:
	died.emit()
	queue_free()
