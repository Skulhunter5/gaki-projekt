class_name SearchEnemyState extends EnemyMovementState

func enter() -> void:
	enemy.search_timer = 0.0
	enemy.nav_agent.set_target_position(enemy.search_position)
	enemy.return_position = enemy.global_transform.origin

func exit() -> void:
	pass


func update(delta : float) -> void:
	if enemy.nav_agent.is_navigation_finished():
		if enemy.search_timer <= 0.0:
			enemy.search_timer = enemy.search_wait_time
			enemy.velocity = Vector3.ZERO
		else:
			enemy.search_timer -= delta
			if enemy.search_timer <= 0.0:
				transition.emit("ReturnEnemyState")
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
	enemy.nav_agent.set_target_position(enemy.search_position)
