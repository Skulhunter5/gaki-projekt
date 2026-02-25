class_name HitboxComponent
extends Area3D

@export var damage: float = 1.0

@warning_ignore("unused_signal")
signal hit(hurtbox: HurtboxComponent)
