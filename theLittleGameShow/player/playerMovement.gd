extends CharacterBody2D


var SPEED = 0.0
var JUMP_VELOCITY = -200.0

var maxSpeed = 75.0
var lastDirection = 0

@onready var sprite = $sprite

func _physics_process(delta: float) -> void:

	var direction := Input.get_axis("playerLeft", "playerRight")
	if direction:
		SPEED = lerp(SPEED, maxSpeed, 0.08)
		velocity.x = direction * SPEED
	
	if lastDirection != direction:
		lastDirection = direction
		SPEED = lerp(SPEED, 0.0, 0.08)
	
	if !direction:
		SPEED = lerp(SPEED, 0.0, 0.08)
		velocity.x = lerp(velocity.x, 0.0, 0.08)
	
	if direction == 1:
		sprite.flip_h = false
	if direction == -1:
		sprite.flip_h = true
	
	lastDirection = direction
	move_and_slide()
