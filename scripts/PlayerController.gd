extends KinematicBody2D

export var acceleration = 25
export var max_speed = 100
export var friction = 25

var velocity = Vector2.ZERO

signal hit

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * acceleration * delta
		velocity = velocity.clamped(max_speed * delta)
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
