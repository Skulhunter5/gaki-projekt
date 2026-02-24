extends Decal


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(20).timeout
	queue_free()
