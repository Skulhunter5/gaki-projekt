class_name DeadEnemyState extends EnemyMovementState

func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta : float) -> void:
	pass


func physics_update(_delta : float) -> void:#
	pass
	# needed?????
	#update_timer -= delta
	#if update_timer <= 0.0:
		#new_nav_agent_target()
		#update_timer = update_interval


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
