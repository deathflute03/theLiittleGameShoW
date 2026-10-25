extends Node2D

@export var cheese_scene: PackedScene
@export var drop_scene: PackedScene
@export var bin_scene: PackedScene

@onready var music = $"../music"
@onready var timer = $"../spawnTimer"

var time_elapsed = 0.0
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	music.play()
	
	timer.wait_time = 2.0 
	timer.autostart = true
	if not timer.timeout.is_connected(_on_spawn_timer_timeout):
		timer.timeout.connect(_on_spawn_timer_timeout)
	timer.start()

func _on_spawn_timer_timeout() -> void:
	if globalValues.playerHealth <= 0:
		return
	
	var player = get_tree().get_first_node_in_group("PlayerScene")
	var amount = randi_range(1, 2)
	var spawned_x_positions: Array = []
	var min_distance = 24.0
	
	for i in range(amount):
		var num = rng.randi_range(0, 99)
		var selected_scene: PackedScene = null

		if num < 5:
			selected_scene = cheese_scene
		elif num < 70:
			selected_scene = drop_scene
		else:
			selected_scene = bin_scene
			
		if selected_scene:
			var spawn_x = 0.0
			var valid_position = false
			var attempts = 0
			
			while not valid_position and attempts < 10:
				attempts += 1
				
				if player:
					var offset = randf_range(-40.0, 40.0)
					spawn_x = player.global_position.x + offset
				else:
					spawn_x = randf_range(0.0, 128.0)
				
				spawn_x = clamp(spawn_x, 8.0, 120.0)
				
				var too_close = false
				for prev_x in spawned_x_positions:
					if abs(spawn_x - prev_x) < min_distance:
						too_close = true
						break
				
				if not too_close:
					valid_position = true
			
			if not valid_position:
				continue
				
			spawned_x_positions.append(spawn_x)
			
			var instance = selected_scene.instantiate()
			instance.global_position.x = spawn_x
			instance.position.y = -32
			get_parent().add_child.call_deferred(instance)

func _process(delta: float) -> void:
	if globalValues.initalCutsceneDone == true:
		time_elapsed += delta
		timer.wait_time = max(0.4, 2.0 - (time_elapsed * 0.015))
	else:
		timer.wait_time = 100
	
	if globalValues.playerHealth <= 0:
		get_tree().paused = true
		sceneTransition.change_scene_to("res://deathScreen/deathScreen.tscn", 1, 0.5, "BLACK")
