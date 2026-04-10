extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Left and right only (endless runner — no up/down movement)
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Lock Z axis — player only moves left/right
	velocity.z = 0

	move_and_slide()
