class_name EnemyStateMachine extends StateMachine

func _process(delta: float) -> void:
	current_state.update(delta)
