class_name PatrolEnemyState extends EnemyMovementState

func enter() -> void:
	enemy.patrol_timer = 0
	enemy.next_waypoint()


func exit() -> void:
	pass


func update(delta : float) -> void:
	if enemy.nav_agent.is_navigation_finished():
		if enemy.patrol_timer <= 0.0:
			enemy.patrol_timer = enemy.patrol_wait_time
			enemy.velocity = Vector3.ZERO
		else:
			enemy.patrol_timer -= delta
			if enemy.patrol_timer <= 0.0:
				enemy.next_waypoint()
	else:
		enemy.go_to(enemy.nav_agent.get_next_path_position())
		
	if enemy.player_in_sight():
		transition.emit("FollowEnemyState")


func physics_update(delta : float) -> void:
	enemy.update_timer -= delta
	if enemy.update_timer <= 0.0:
		new_nav_agent_target()
		enemy.update_timer = enemy.update_interval


func new_nav_agent_target() -> void:
	if enemy.waypoints.size() > 0:
		enemy.nav_agent.set_target_position(enemy.waypoints[enemy.patrol_index].global_transform.origin)
