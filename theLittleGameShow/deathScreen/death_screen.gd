extends Control


@onready var rank : AnimatedSprite2D = $canvas/rank 
@onready var scoreLabel : Label = $canvas/scoreLabel
@onready var playAgain : TextureButton = $canvas/playAgain
@onready var music = $music

var rankBobTime = 0.0
var rankBobFreq = 4
var rankBobAmp = 2

var canPlayAgain = false

var normalButtonSize: Vector2

var totalScore

var originalRankPosition : Vector2
var originalButtonPosition : Vector2


func _ready() -> void:
	music.play()
	totalScore = globalValues.score
	scoreLabel.text = "Score: " + str(globalValues.score)
	
	originalRankPosition = rank.position
	originalButtonPosition = playAgain.position
	normalButtonSize = playAgain.scale
	
	
	playAgain.modulate.a = 0.0
	rank.modulate.a = 0.0
	
	showRank()

func _enablePlayAgain():
	canPlayAgain = true

func showRank():
	if globalValues.score < 300:
		rank.play("bad")
	elif globalValues.score < 600:
		rank.play("ok")
	elif globalValues.score < 1000:
		rank.play("sick")
	

	var mat = rank.material as ShaderMaterial
	if not mat:
		return
		
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/flash_value", 1.0, 0.0)
	tween.tween_property(rank, "modulate:a", 1.0, 3.0)
	tween.tween_property(mat, "shader_parameter/flash_value", 0.0, 4.0)
	tween.tween_callback(_enablePlayAgain)
	tween.tween_property(playAgain, "modulate:a", 1.0, 1.0)
	

func _Bob(time, originalPos, freq, amp):
	var position : float
	position = originalPos.y + sin(rankBobTime * freq) * amp
	return position

func _process(delta: float) -> void:
	rankBobTime += delta
	
	rank.position.y = _Bob(rankBobTime, originalRankPosition, rankBobFreq, rankBobAmp)
	playAgain.position.y = _Bob(rankBobTime, originalButtonPosition, 4, 1)
	
	if canPlayAgain == false:
		playAgain.disabled = true
	else:
		playAgain.disabled = false


func _on_play_again_pressed() -> void:
	globalValues.playerHealth = 3
	globalValues.score = 0
	globalValues.initalCutsceneDone = false
	sceneTransition.change_scene_to("res://scenes/mainGame/mainGame.tscn", 0.5, 0.5, "WHITE")
