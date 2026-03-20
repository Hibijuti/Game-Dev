extends Label3D

var speed = 1.0

func _process(delta):
	translate(Vector3(speed * delta, 0, 0))
