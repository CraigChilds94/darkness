extends Node2D

var menu_button : TextureButton

func _ready():
	menu_button = get_node("MenuButton")
	var score_label = get_node("Score")
	score_label.set_text("Score: " + str(_get_score()))
	var level_label = get_node("Level")
	level_label.set_text("Level: " + str(_get_level()))
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		menu_button.grab_focus()
		menu_button.emit_signal("pressed")

func _get_score():
	return Game.get_current_points()
	
func _get_level():
	return Game.get_current_level()

func _on_MenuButton_pressed():
	queue_free()
	Game.reset()
	Global.goto_scene("res://Menu.tscn")


func _on_GameMusic_finished():
	get_node("GameMusic").play()
