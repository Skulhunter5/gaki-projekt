extends VBoxContainer

@onready var scoreLabel: Label = $ScoreLabel
@onready var highscoreLabel: Label = $HighscoreLabel

func _ready() -> void:
	ScoreManager.score_changed.connect(_on_score_change)
	_on_score_change(ScoreManager.score, ScoreManager.highscore)
	return

func _on_score_change(new_score: int, highscore: int) -> void:
	scoreLabel.text = "Score: %d" % new_score
	highscoreLabel.text = "Highscore: %d" % highscore
