extends Control

@onready var health: Range = $canvas/health

var bob_time := 0.0
var bob_amp := 2
var bob_freq := 4
var health_start_position: Vector2

func _ready() -> void:
	health_start_position = health.position

func _process(delta: float) -> void:
	bob_amp = 2 + globalValues.playerHealth / 10
	bob_time += delta
	health.position.y = health_start_position.y + sin(bob_time * bob_freq) * bob_amp

	globalValues.playerHealth = clampi(globalValues.playerHealth, 0, 3)
	health.value = globalValues.playerHealth
