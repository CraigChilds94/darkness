extends Node

export var save_path = "user://savegame.save"
var current_scene = null
var high_score : int = 0
var current_score : int = 0

func _ready():
	load_game()
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func update_score(score):
	current_score = score
	if current_score > high_score:
		high_score = current_score

func reset_score():
	high_score = 0
	save_game()

func save_game():
	var file = File.new()
	file.open(save_path, File.WRITE)
	
	var data = {
		"high_score": high_score
	}
	
	file.store_line(to_json(data))
	file.close()
	
func load_game():
	var file = File.new()
	
	if not file.file_exists(save_path):
		high_score = 0
		save_game()
		return
	
	file.open(save_path, File.READ)
	var data = parse_json(file.get_line())
	high_score = data["high_score"]
	file.close()

func get_high_score():
	return high_score

func _deferred_goto_scene(path):
	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
