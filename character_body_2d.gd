extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite = $AnimatedSprite2D

var hp = 100
var health_bar
var score = 0
var score_label

@export var player_id = 1

func _ready():
	# Set multiplayer authority
	set_multiplayer_authority(player_id)
	
	# Create health bar
	health_bar = ProgressBar.new()
	health_bar.max_value = 100
	health_bar.value = 100
	health_bar.show_percentage = false
	health_bar.size = Vector2(150, 20)
	health_bar.position = Vector2(-70, -160)
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 1, 0)
	health_bar.add_theme_stylebox_override("fill", style)
	
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color(0.3, 0, 0)
	health_bar.add_theme_stylebox_override("background", bg_style)
	add_child(health_bar)

	var canvas = CanvasLayer.new()
	score_label = Label.new()
	score_label.text = "Score: 0"
	score_label.position = Vector2(20, 20)
	score_label.add_theme_font_size_override("font_size", 24)
	canvas.add_child(score_label)
	add_child(canvas)

	call_deferred("spawn_enemy")

func spawn_enemy():
	var enemy = CharacterBody2D.new()
	
	var enemy_collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(50, 80)
	enemy_collision.shape = shape
	enemy.add_child(enemy_collision)
	
	var enemy_sprite = Sprite2D.new()
	var image = Image.create(50, 80, false, Image.FORMAT_RGB8)
	image.fill(Color(1, 0, 0))
	var texture = ImageTexture.create_from_image(image)
	enemy_sprite.texture = texture
	enemy.add_child(enemy_sprite)
	
	enemy.position = Vector2(300, -200)
	get_parent().add_child(enemy)
	print("Enemy spawned at: ", enemy.position)

func add_score(amount):
	score += amount
	if score_label != null:
		score_label.text = "Score: " + str(score)

@rpc("any_peer", "unreliable")
func sync_position(pos):
	if not is_multiplayer_authority():
		global_position = pos

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_multiplayer_authority():
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			add_score(1)

		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if direction > 0:
			animated_sprite.play("lebron right")
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.play("lebron left")
			animated_sprite.flip_h = false

		move_and_slide()

		# Sync position to other player
		sync_position.rpc(global_position)

func take_damage(amount):
	hp -= amount
	if health_bar != null:
		health_bar.value = hp
	if hp <= 0:
		get_tree().reload_current_scene()
