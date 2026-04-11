extends CharacterBody2D

func _ready():
	print("ENEMY READY")

func _physics_process(delta):
	velocity += get_gravity() * delta
	move_and_slide()
