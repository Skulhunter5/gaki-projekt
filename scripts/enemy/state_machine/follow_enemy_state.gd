class_name FollowEnemyState extends EnemyMovementState

func enter() -> void:
	enemy.return_position = enemy.global_transform.origin


func exit() -> void:
	pass


func update(_delta : float) -> void:
	if not enemy.player:
		transition.emit("ReturnEnemyState")
		return
	
	enemy.go_to(enemy.nav_agent.get_next_path_position())
	
	if enemy.global_transform.origin.distance_to(enemy.player.global_transform.origin) < enemy.engagement_distance:
		transition.emit("ShootEnemyState")
	elif not enemy.player_in_sight():
		enemy.search_position = enemy.player.global_transform.origin
		enemy.search_position.y += 2
		transition.emit("SearchEnemyState")


func physics_update(delta : float) -> void:
	enemy.update_timer -= delta
	if enemy.update_timer <= 0.0:
		new_nav_agent_target()
		enemy.update_timer = enemy.update_interval


func new_nav_agent_target() -> void:
	if enemy.player:
		enemy.nav_agent.set_target_position(enemy.player.global_transform.origin)
