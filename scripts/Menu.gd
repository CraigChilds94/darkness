extends Node2D

var play_button : TextureButton

func _ready():
	play_button = get_node("PlayButton")
	var high_score = Global.get_high_score()
	var high_score_label = get_node("HighScore")
	high_score_label.set_text("High Score: " + str(high_score))
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		play_button.grab_focus()
		play_button.emit_signal("pressed")

func _get_high_score():
	return Global.load_high_score()

func _on_PlayButton_pressed():
	queue_free()
	Global.goto_scene("res://Level.tscn")


func _on_GameMusic_finished():
	get_node("GameMusic").play()
