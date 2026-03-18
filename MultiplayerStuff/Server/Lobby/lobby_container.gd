extends Node
class_name LobbyContainer

#might have to have a bool, if match started then always spawn the map if not there, this is so people late to joining gets synced up
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
	
