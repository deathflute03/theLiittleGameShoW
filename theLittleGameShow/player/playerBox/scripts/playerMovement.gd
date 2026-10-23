extends CharacterBody2D


var SPEED = 0.0
var JUMP_VELOCITY = -200.0
var maxSpeed = 75.0

@onready var animSprite = $animSprite


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("playerJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("playerLeft", "playerRight")
	if direction:
		SPEED = lerp(SPEED, maxSpeed, 0.1)
		velocity.x = direction * SPEED
	else:
		SPEED = lerp(SPEED, 0.0, 0.05)
		velocity.x = lerp(velocity.x, 0.0, 0.08)
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	
	animation(direction)
	move_and_slide()

func animation(direction):
	
	if direction ==-1:
		animSprite.flip_h = true
	if direction == 1:
		animSprite.flip_h = false
	
	if direction and is_on_floor():
		animSprite.play("walk")
		
	if !direction:
		animSprite.play("idle")
	
	if !is_on_floor():
		animSprite.play("jumpAir")
