extends Control

@onready var music = $CanvasLayer/music
@onready var display = $CanvasLayer/display
@onready var introRect = $CanvasLayer/introRect
@onready var clickSound = $CanvasLayer/clickSound
@onready var nextButton = $CanvasLayer/nextButton

var dontTouchImage = "res://intro/dontTouchProjectiles.png"
var getCheeseImage = "res://intro/get_cheese!.png"
var goodLuckImage = "res://intro/goodLuck.png"
var howToMoveImage = "res://intro/howToMove.png"

var images = [howToMoveImage, dontTouchImage, getCheeseImage, goodLuckImage]
var imageNum = 0

var originalDisplayPosition : Vector2
var bobTime = 0.0

func _ready() -> void:
	originalDisplayPosition = display.position
	music.play()
	
	introRect.show()
	var tween = create_tween()
	tween.tween_property(introRect, "modulate:a", 0.0, 2)
	tween.tween_callback(introRect.queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bobTime += delta
	display.position.y = _Bob(bobTime, originalDisplayPosition, 4,4)

func _Bob(time, originalPos, freq, amp):
	var position : float
	position = originalPos.y + sin(time * freq) * amp
	return position

func _loadImage():
	var tween = create_tween()
	tween.tween_property(display, "modulate:a", 0.0, 0.2)
	
	var image = load(images[imageNum])
	display.texture = image
	
	tween.tween_property(display, "modulate:a", 1.0, 0.2)
	await tween.finished


func _on_next_button_pressed() -> void:
	if imageNum < len(images) -1:
		imageNum += 1
		_loadImage()
		clickSound.play()
	else:
		clickSound.play()
		await clickSound.finished
		sceneTransition.change_scene_to("res://scenes/mainGame/mainGame.tscn", 0.5, 0.5, "WHITE")
