extends Map
class_name HM

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_gamemode():
	pass

func end_gamemode():
	pass #not gonna happen -._-

func player_died(merc : Merc):
	pass #not gonna happen -_.-

func _on_player_joined(peer_id: int):
	if !multiplayer.is_server(): return
	await get_tree().create_timer(1.0).timeout
	player_spawner.spawn({'merc_type' = 'default', "peer_id" = peer_id, "position" = Vector3.ZERO})
	
func _on_player_left(player_id: int):
	pass

func custom_ready():
	pass

func custom_process(delta : float):
	pass
