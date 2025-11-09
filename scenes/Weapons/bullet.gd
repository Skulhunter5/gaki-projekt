class_name Bullet
extends Area3D

var velocity: float

func _physics_process(delta: float) -> void:
	print(velocity)
	position += -transform.basis.z * velocity * delta

func _on_body_entered(body: Node3D) -> void:
	if not is_queued_for_deletion():
		print(body)
		queue_free()
