extends Control

@onready var health: Range = $canvas/health
@onready var score: Label = $canvas/score
@onready var canvas = $canvas

var bob_time := 0.0
var bob_amp := 2
var bob_freq := 4
var health_start_position: Vector2
var score_start_position: Vector2
var score_start_rotation: float

func _ready() -> void:
	score_start_position = score.position
	health_start_position = health.position
	score_start_rotation = score.rotation_degrees

func _process(delta: float) -> void:
	if globalValues.initalCutsceneDone == false:
		canvas.hide()
	else:
		canvas.show()
	
	bob_amp = 2 + globalValues.playerHealth / 10
	bob_time += delta
	
	score.text = str(globalValues.score)
	
	score.position.y = score_start_position.y + sin(bob_time * bob_freq) * bob_amp /5
	score.rotation_degrees = score_start_rotation + sin(bob_time * bob_freq) * bob_amp / 5
	
	health.position.y = health_start_position.y + sin(bob_time * bob_freq) * bob_amp

	globalValues.playerHealth = clampi(globalValues.playerHealth, 0, 3)
	health.value = globalValues.playerHealth
