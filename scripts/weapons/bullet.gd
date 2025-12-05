extends RigidBody3D


func _on_body_entered(body: Node) -> void:
	print("freeing")
	queue_free()
