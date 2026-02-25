class_name ReturnEnemyState extends EnemyMovementState

func enter() -> void:
	enemy.nav_agent.set_target_position(enemy.return_position)


func exit() -> void:
	pass


func update(_delta : float) -> void:
	if enemy.waypoints.is_empty():
		if enemy.nav_agent.is_navigation_finished():
			transition.emit("IdlePlayerState")
		else:
			enemy.go_to(enemy.nav_agent.get_next_path_position())
		return
	if enemy.nav_agent.is_navigation_finished() and not enemy.waypoints.is_empty():
		transition.emit("PatrolEnemyState")
	elif enemy.player_in_sight():
		transition.emit("FollowEnemyState")
	else:
		enemy.go_to(enemy.nav_agent.get_next_path_position())


func physics_update(delta : float) -> void:
	enemy.update_timer -= delta
	if enemy.update_timer <= 0.0:
		new_nav_agent_target()
		enemy.update_timer = enemy.update_interval


func new_nav_agent_target() -> void:
	enemy.nav_agent.set_target_position(enemy.return_position)
