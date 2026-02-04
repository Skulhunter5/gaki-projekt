extends Node

signal score_changed(score: int, highscore: int)

var score: int = 0
var highscore: int = 0

func _ready() -> void:
	score_changed.emit(score, highscore)

func save_highscore() -> void:
	# TODO: save the highscore
	pass

func load_highscore() -> void:
	# TODO: load the previously saved highscore
	highscore = 0
	score_changed.emit(score, highscore)

func reset():
	score = 0
	score_changed.emit(score, highscore)

func add_score(amount: int) -> int:
	score += amount
	
	if score > highscore:
		highscore = score
		save_highscore()
	
	score_changed.emit(score, highscore)
	
	return score
