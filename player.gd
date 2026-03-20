extends CharacterBody2D

var speed = 200
var dodge_speed = 600
var is_dodging = false
var direction = Vector2.ZERO

func _physics_process(delta):
	if not is_dodging:
		direction = Vector2.ZERO

		if Input.is_action_pressed("ui_right"):
			direction.x += 1
		if Input.is_action_pressed("ui_left"):
			direction.x -= 1
		if Input.is_action_pressed("ui_down"):
			direction.y += 1
		if Input.is_action_pressed("ui_up"):
			direction.y -= 1

		direction = direction.normalized()
		velocity = direction * speed

	move_and_slide()

func _input(event):
	if event.is_action_pressed("dodge") and not is_dodging:
		dodge()

func dodge():
	if direction == Vector2.ZERO:
		return

	is_dodging = true
	velocity = direction * dodge_speed

	await get_tree().create_timer(0.2).timeout
	is_dodging = false
