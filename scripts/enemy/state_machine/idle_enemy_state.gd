class_name IdleEnemyState extends EnemyMovementState

func enter() -> void:
	enemy.velocity = Vector3.ZERO
	enemy.nav_agent.set_target_position(enemy.global_position)
	if enemy.player_in_sight():# or player_in_hearing_range():
		transition.emit("FollowEnemyState")


func exit() -> void:
	pass


func update(_delta : float) -> void:
	pass


func physics_update(_delta : float) -> void:
	pass
	# needed ??????
	#enemy.update_timer -= delta
	#if enemy.update_timer <= 0.0:
		#new_nav_agent_target()
		#enemy.update_timer = enemy.update_interval


	#func new_nav_agent_target() -> void:
	#match state:
			#States.PATROL:
				#if waypoints.size() > 0:
					#nav_agent.set_target_position(waypoints[patrol_index].global_transform.origin)
			#States.SEARCH:
				#nav_agent.set_target_position(search_position)
			#States.FOLLOW:
				#if player:
					#nav_agent.set_target_position(player.global_transform.origin)
			#States.RETURN:
				#nav_agent.set_target_position(return_position)
