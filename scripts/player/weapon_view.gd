extends Camera3D

@export var main_camera: Camera3D

func _ready() -> void:
	top_level = true
	process_priority = 1  

func _process(_delta: float) -> void:
	global_transform = main_camera.global_transform
