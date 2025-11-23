class_name State

extends Node
@warning_ignore("unused_signal")
signal transition(new_state_name : StringName)


func enter() -> void:
	pass


func exit() -> void:
	pass


@warning_ignore("unused_parameter")
func update(delta : float) -> void:
	pass


@warning_ignore("unused_parameter")
func physics_update(delta : float) -> void:
	pass


@warning_ignore("unused_parameter")
func handle_input(event: InputEvent):
	pass
