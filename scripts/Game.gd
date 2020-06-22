extends Node

var current_level = 1
var level_modifier = 0.25
var level_bonus = 300

var current_points = 0 
var lights_collected = 0

func next_level():
	current_level += 1
	current_points += level_bonus
	lights_collected = 0

func get_current_level():
	return current_level

func add_points(points):
	current_points += int(points)

func get_current_points():
	return current_points

func collect_light():
	lights_collected += 1

func get_lights_collected():
	return lights_collected

func get_level_modifier():
	return level_modifier

func apply_level_modifier(value):
	return value + (value * ((current_level - 1) * level_modifier))

func reset():
	current_level = 1
	current_points = 0
	lights_collected = 0
