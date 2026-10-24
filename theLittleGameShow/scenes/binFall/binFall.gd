extends CharacterBody2D


var SPEED = 0.0
var maxSpeed = 300.0
var JUMP_VELOCITY = -400.0

var was_on_floor = false

@onready var camera = $"../camera"


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		SPEED = lerp(SPEED, maxSpeed, 0.08)
		velocity.y +=  SPEED * delta
	if is_on_floor() and was_on_floor == false:
		was_on_floor = true
		camera.trigger_shake()
	move_and_slide()
