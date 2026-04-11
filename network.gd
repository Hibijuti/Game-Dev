extends Node

const PORT = 7777
const MAX_PLAYERS = 2

func host_game():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_PLAYERS)
	multiplayer.multiplayer_peer = peer
	print("Hosting on port: ", PORT)

func join_game(ip):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer
	print("Joining: ", ip)
