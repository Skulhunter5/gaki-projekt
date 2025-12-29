extends RigidBody3D


func _on_body_entered(body: Node) -> void:
	print("freeing")
	print(body)
	queue_free()
