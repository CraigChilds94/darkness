extends KinematicBody2D

export var acceleration = 25
export var max_speed = 100
export var friction = 25

var velocity = Vector2.ZERO
export var energy = 100
var energy_use = 50
var energy_regen = 10

signal hit

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	var sprint_multiplier = 1
	var energy_left = max(0, energy - (energy_use * delta))
	
	if Input.is_action_pressed("ui_accept"):
		if energy_left > 0:
			sprint_multiplier = 2
			energy = floor(max(0, energy_left))
	else:
		energy = min(100, energy + (energy_regen * delta))
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * acceleration * delta
		velocity = velocity.clamped((max_speed * sprint_multiplier) * delta)
		$Sprite/Tail.emitting = true
		
		var angle_radians = $Sprite.position.angle_to(velocity)
		$Sprite.rotation = lerp($Sprite.rotation, angle_radians, 1)
	
		$Sprite/Tail.set_param(CPUParticles.PARAM_ANGLE, rad2deg(angle_radians))
	
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
