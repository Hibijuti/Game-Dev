extends Node2D

var player_scene = preload("res://Lebron.tscn")
@export var player_id = 1

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	
	# Spawn locddwal player
	spawn_player(multiplayer.get_unique_id())

func _on_player_connected(id):
	print("Player connected: ", id)
	spawn_player(id)

func _on_player_disconnected(id):
	print("Player disconnected: ", id)
	if has_node(str(id)):
		get_node(str(id)).queue_free()

func spawn_player(id):
	var player = player_scene.instantiate()
	player.name = str(id)
	player.player_id = id
	
	# Offset second player position so they don't overlap
	if id == multiplayer.get_unique_id():
		player.position = Vector2(200, -200)
	else:
		player.position = Vector2(400, -200)
	
	add_child(player)
	print("Spawned player: ", id)
