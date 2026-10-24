extends CharacterBody2D


var SPEED = 0.0
var maxSpeed = 300.0
var JUMP_VELOCITY = -400.0

var damage = 3
var score = 40
var heal = 0

var warning_done = false
var was_on_floor = false


@onready var sprite = $sprite2D
@onready var camera = $"../camera"
@onready var warningSprite = $warningSprite
@onready var fallAudio = $audioFall
@onready var audioAlert = $audioAlert

func addScore():
	globalValues.score += score
	
func RemoveHealth():
	globalValues.playerHealth = 0
	
func addHealth():
	globalValues.playerHealth += heal


func _ready() -> void:
	warning()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if warning_done:
		if not is_on_floor():
			sprite.play("normal")
			SPEED = lerp(SPEED, maxSpeed, 0.08)
			velocity.y +=  SPEED * delta
		
		if is_on_floor() and was_on_floor == false:
			fallAudio.play()
			addScore()
			sprite.play("ground")
			was_on_floor = true
			camera.trigger_shake()
	move_and_slide()

func warning():
	audioAlert.play()    
	var tween = get_tree().create_tween()
	
	for i in range(2):
		tween.tween_callback(audioAlert.play)
		tween.tween_property(warningSprite, "modulate:a", 1.0, 0.5)       
		tween.tween_property(warningSprite, "modulate:a", 0.0, 0.5)
	
	
	tween.tween_interval(0.1)
	tween.tween_callback(warningDone)

func warningDone():
	warning_done = true

func _on_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.name == "PlayerScene":
			if not is_on_floor():
				var tween = get_tree().create_tween()
				tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
				tween.parallel().tween_property(self, "scale", Vector2(0.2,0.2), 0.2)
			
				tween.tween_callback(RemoveHealth)
				tween.tween_callback(queue_free)
			else:
				return
