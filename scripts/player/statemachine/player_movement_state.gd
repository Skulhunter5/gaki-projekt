class_name PlayerMovementState extends State

var player : Player

func _ready():
	await owner.ready
	player = owner as Player
