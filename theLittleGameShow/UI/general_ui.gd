extends Control

@onready var hpLabel = $canvas/hpLabel
@onready var scoreLabel = $canvas/scoreLabel

func _process(delta: float) -> void:
	scoreLabel.text = str(globalValues.score)
	hpLabel.text = "HP: " + str(globalValues.playerHealth)
