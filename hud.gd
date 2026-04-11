extends CanvasLayer

var score = 0
var health = 100

@onready var score_label = $ScoreLabel
@onready var health_bar = $HealthBar

func update_score(amount):
	score += amount
	score_label.text = "Score: " + str(score)

func update_health(amount):
	health = clamp(health + amount, 0, 100)
	health_bar.value = health
