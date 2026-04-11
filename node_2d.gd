extends Node2D

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected)
	
	# Connect buttons through code
	$VBoxContainer/HostButton.pressed.connect(_on_HostButton_pressed)
	$VBoxContainer/JoinButton.pressed.connect(_on_JoinButton_pressed)
	
	# Fix UI sizing and text
	$VBoxContainer.position = Vector2(400, 250)
	$VBoxContainer/HostButton.custom_minimum_size = Vector2(200, 50)
	$VBoxContainer/HostButton.text = "Host Game"
	$VBoxContainer/JoinButton.custom_minimum_size = Vector2(200, 50)
	$VBoxContainer/JoinButton.text = "Join Game"
	$VBoxContainer/IPInput.custom_minimum_size = Vector2(200, 40)
	$VBoxContainer/IPInput.placeholder_text = "Enter Host IP"
func _on_HostButton_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(7777, 2)
	multiplayer.multiplayer_peer = peer
	print("Hosting game...")
	get_tree().change_scene_to_file("res://primary_node.tscn")

func _on_JoinButton_pressed():
	var ip = $VBoxContainer/IPInput.text
	if ip == "":
		ip = "127.0.0.1"
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, 7777)
	multiplayer.multiplayer_peer = peer
	print("Joining game at: ", ip)

func _on_connected():
	print("Connected to server!")
	get_tree().change_scene_to_file("res://primary_node.tscn")

func _on_player_connected(id):
	print("Player connected: ", id)

func _on_player_disconnected(id):
	print("Player disconnected: ", id)
