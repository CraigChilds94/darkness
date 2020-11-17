extends KinematicBody2D

export var acceleration = 25
export var max_speed = 100
export var friction = 25

var velocity = Vector2.ZERO
export var energy = 100

signal hit

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	var sprint_multiplier = 1
	if energy > 0 and Input.is_action_pressed("ui_accept"):
		sprint_multiplier = 1.25
		energy = max(0, energy - (50 * delta))
	else:
		energy = min(100, energy + (10 * delta))
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * acceleration * delta
		velocity = velocity.clamped((max_speed * sprint_multiplier) * delta)
		$Sprite/Tail.emitting = true
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		$Sprite/Tail.emitting = false
	
	var collision = move_and_collide(velocity)
	
	if collision:
		_handle_collision(collision)

func _handle_collision(collision):
	var light = collision.collider
	
	if light.is_visible():
		light.hide()
		light.free()
		emit_signal("hit")
