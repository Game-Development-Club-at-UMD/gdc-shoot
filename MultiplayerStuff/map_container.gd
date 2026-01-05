extends Node
class_name MapContainer

@rpc('any_peer', "call_local")
func create_new_lobby(lobby_id: String):
	if !multiplayer.is_server():
		create_new_lobby.rpc_id(1, lobby_id)
		return
	print('something is making a lobby')
	var lobby_scene : PackedScene = load("res://Maps/Lobby/Lobby.tscn")
	var lobby_instance = lobby_scene.instantiate()
	
	lobby_instance.name = str(lobby_id)
	add_child(lobby_instance, true)
