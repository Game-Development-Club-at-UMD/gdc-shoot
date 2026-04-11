extends Control

var current_lobby : String

func _ready() -> void:
	ServerDatabase.connect("lobbies_updated", update_lobby_ui)

func update_lobby_ui():
	return
	for i : String in ServerDatabase.Lobbies:
		for k in ServerDatabase[i]:
			if k.has(multiplayer.get_unique_id()):
				current_lobby = i

func _on_leave_lobby_pressed() -> void:
	pass # Replace with function body.
