extends Node
class_name ServerLogic

var port = 6789
var map_container : MapContainer = null

func _ready() -> void:
	name = "NetworkConnection"
	var peer = ENetMultiplayerPeer.new()
	
	var error = peer.create_server(port)
	if error != OK:
		print("Failed to start server, error code: ", error)
		return
	
	#plugging the battery into the walkie talkie
	multiplayer.multiplayer_peer = peer
	print('server started :D on port ', port)
	
	await get_tree().create_timer(.5).timeout #debug server lobby
	create_new_lobby("server_lobby")

func create_new_lobby(id : String): map_container.create_new_lobby.rpc_id(1, id) #not exactly needed, you could call it local since we know this zastard is the server but idk this could do some cool stuff lol
