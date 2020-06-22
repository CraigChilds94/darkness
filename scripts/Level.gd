extends Node2D

export var padding = 20

var visibility : float = 100

var score_label : Label
var level_label : Label
var player : KinematicBody2D
var player_light : Light2D
var base_texture_scale : float
var new_texture_scale : float
var game_over_threshold : float = 0.1

export var game_over_scene = "res://GameOver.tscn"
export var time_points_bonus = 10
export var visibility_increase = 5
export var darkness_rate = 10
export var number_of_lights = 10
export var screen_size = Vector2()

var time_elapsed = 1

var loading
var light_audio : AudioStreamPlayer2D
var game_music : AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	loading = false
	game_music = get_node("GameMusic")
	light_audio = get_node("LightCollectedAudio")
	player = get_node("Player")
	player_light = player.get_node("Camera2D/Light2D")
	score_label = player.get_node("Score")
	score_label.set_text("Score: " + str(Game.get_current_points()))
	level_label = player.get_node("CurrentLevel")
	level_label.set_text("Level: " + str(Game.get_current_level()))
	
	base_texture_scale = player_light.texture_scale
	screen_size = get_viewport_rect().size
	
	number_of_lights = int(Game.apply_level_modifier(number_of_lights))
	darkness_rate = Game.apply_level_modifier(darkness_rate)
	
	for _n in range(0, number_of_lights):
		_spawn_light()

func _process(delta):
	visibility -= darkness_rate * delta
	new_texture_scale = base_texture_scale * ((visibility / 100))
	player_light.texture_scale = new_texture_scale
	
	if !loading && Game.get_lights_collected() == number_of_lights:
		loading = true
		Global.update_score(Game.get_current_points())
		Global.save_game()
		visibility = 100
		Game.next_level()
		get_tree().reload_current_scene()
	elif !loading && player_light.texture_scale <= game_over_threshold:
		Global.update_score(Game.get_current_points())
		Global.save_game()
		queue_free()

		Global.goto_scene(game_over_scene)

func _on_Player_hit():
	light_audio.stop()
	light_audio.play()
	var new_points = (darkness_rate * number_of_lights) / 10
	Game.collect_light()
	Game.add_points(new_points + (time_points_bonus - time_elapsed))
	visibility += visibility_increase
	score_label.set_text("Score: " + str(Game.get_current_points()))
	print("Collected " + str(Game.get_lights_collected()) + " of " + str(number_of_lights))

func _get_random_position():
	return Vector2(rand_range(padding, screen_size.x - padding), rand_range(padding, screen_size.y - padding))

func _spawn_light():
	var Light = get_node("Light")
	var light = Light.duplicate()
	light.show()
	light.position = _get_random_position()
	add_child(light)

func _on_TimeElapsedTimer_timeout():
	time_elapsed += 1

func _on_GameMusic_finished():
	game_music.play()
