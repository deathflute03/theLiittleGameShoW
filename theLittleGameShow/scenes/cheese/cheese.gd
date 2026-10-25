extends CharacterBody2D


var SPEED = 0.0
var maxSPEED = randf_range(65, 75)
var damage = 0
var score = 20
var heal = 1

@onready var sprite = $sprite
@onready var sound = $sound
@onready var audioLanding = $audioLanding

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		SPEED = lerp(SPEED, maxSPEED, 0.08)
		velocity.y += SPEED * delta
	

	checkFinish()
	move_and_slide()

var finishing := false

func checkFinish():
	if is_on_floor_only() and not finishing:
		finishing = true
		audioLanding.play()
		var tween = get_tree().create_tween()
		tween.tween_property(sprite, "modulate:a", 0.0, 2.5)
		tween.parallel().tween_property(self, "scale", Vector2(0.2,0.2), 2.5)
		tween.tween_callback(queue_free)
		addScore()
		

func addScore():
	
	globalValues.score += score
	
func RemoveHealth():
	globalValues.playerHealth -= damage
	
func addHealth():
	globalValues.playerHealth += heal

func _on_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.name == "PlayerScene":
			
			var tween = get_tree().create_tween()
			tween.tween_callback(sound.play)
			tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
			tween.parallel().tween_property(self, "scale", Vector2(0.2,0.2), 0.2)
			
			tween.tween_callback(addHealth)
			tween.tween_callback(queue_free)
