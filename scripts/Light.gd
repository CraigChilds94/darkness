extends StaticBody2D


var movement = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var random_vector = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	position.x += random_vector.x * movement * delta
	position.y += random_vector.y * movement * delta	
