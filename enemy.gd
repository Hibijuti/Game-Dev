extends CharacterBody2D

const SPEED = 60.0
const JUMP_VELOCITY = -300.0
var direction = 1
var hp = 100
var health_bar
var move_timer = 0.0
var move_time = 2.0
var jump_timer = 0.0
var jump_time = 3.0  # jumps every 3 seconds

func _ready():
	print("Enemy is alive!")
	
	# Create health bar
	health_bar = ProgressBar.new()
	health_bar.max_value = 100
	health_bar.value = 100
	health_bar.show_percentage = false
	health_bar.size = Vector2(300, 20)
	health_bar.position = Vector2(800, 250)
	
	# Red fill
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 0, 0)
	health_bar.add_theme_stylebox_override("fill", style)
	
	# Dark background
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color(0.3, 0, 0)
	health_bar.add_theme_stylebox_override("background", bg_style)
	add_child(health_bar)

func take_damage(amount):
	hp -= amount
	if health_bar != null:
		health_bar.value = hp
	if hp <= 0:
		queue_free()

func _physics_process(delta):
	velocity += get_gravity() * delta
	velocity.x = SPEED * direction

	# Reverse direction every 2 seconds
	move_timer += delta
	if move_timer >= move_time:
		move_timer = 0.0
		direction *= -1
		
	# Jump every 3 seconds
	jump_timer += delta
	if jump_timer >= jump_time and is_on_floor():
		jump_timer = 0.0
		velocity.y = JUMP_VELOCITY

	move_and_slide()
