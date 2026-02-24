class_name EnemyMovementState extends State

var enemy : Enemy

func _ready():
	await owner.ready
	enemy = owner as Enemy
