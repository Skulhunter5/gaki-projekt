class_name PlayerMovementState extends State

var player : Player
var animation : AnimationPlayer
var weapon : WeaponController

func _ready():
	await owner.ready
	player = owner as Player
	animation = player.animationplayer
	weapon = player.weapon_controller
