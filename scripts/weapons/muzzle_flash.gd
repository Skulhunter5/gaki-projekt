extends Node3D

@export var flash_time : float = 0.05

@onready var light := $OmniLight3D
@onready var emitter := $GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func add_muzzle_flash() -> void:
	light.visible = true
	emitter.emitting = true
	await get_tree().create_timer(flash_time).timeout
	light.visible = false
