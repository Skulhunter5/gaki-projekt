class_name SprintingPlayerState

extends State

func enter() -> void:
	Global.player._speed = Global.player.speed_sprinting


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("sprint"):
		transition.emit("WalkingPlayerState")
