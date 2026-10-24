extends CharacterBody2D


const SPEED = 50.0
var damage = 1
var score = 20
var heal = 0

@onready var sprite = $sprite
@onready var sound = $dropletSound

func _physics_process(delta: float) -> void:
	sprite.play("falling")
	if not is_on_floor():
		velocity.y += SPEED * delta
	

	checkFinish()
	move_and_slide()

var finishing := false

func checkFinish():
	if is_on_floor_only() and not finishing:
		finishing = true
		
		sound.play()
		
		var tween = get_tree().create_tween()
		tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
		tween.parallel().tween_property(self, "scale", Vector2(0.2,0.2), 0.2)
		
		
		tween.tween_callback(addScore)
		tween.tween_callback(queue_free)
		

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
			
			tween.tween_callback(RemoveHealth)
			tween.tween_callback(queue_free)
