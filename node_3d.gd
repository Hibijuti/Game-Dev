extends Label

var speed = 100

func _process(delta):
	position.x += speed * delta
