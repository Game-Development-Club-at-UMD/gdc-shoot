extends Node
@onready var map_container: MapContainer = $MapContainer

func _ready() -> void:
	if OS.has_feature("server") or "--server" in OS.get_cmdline_args():
		_setup_server()
	else:
		await get_tree().create_timer(1).timeout
		_setup_client()

func _setup_server():
	get_window().position.x -= ceil(get_window().size.x / 2.0 + 8)
	var server_logic = ServerLogic.new()
	server_logic.map_container = map_container
	add_child(server_logic)

func _setup_client():
	get_window().position.x += ceil(get_window().size.x / 2.0 + 8)
	var client_logic = ClientLogic.new()
	add_child(client_logic)
