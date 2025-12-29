extends AnimationPlayer


func on_animation_played(animation : StringName = &"", custom_blend : float = -1,custom_speed : float = 1.0, from_end : bool = false):
	play(animation, custom_blend, custom_speed, from_end)
