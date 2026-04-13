extends Map
class_name DM
#deathmatch

const LEADER_BOARD = preload("res://MapsAndGamemodes/Gamemodes/PresetGamemodeWidgets/Leaderboard/LeaderBoard.tscn")

var leaderboard: LeaderBoard 
@export var spawn_points: Array[Node3D] = [] 
@export var respawn_delay: float = 5.0 
@export var gamemode_length = 10.0

var respawn_trackers: Dictionary[int, Dictionary] = {}
var match_started: bool = false 

func custom_ready():
	leaderboard = LEADER_BOARD.instantiate()
	add_child(leaderboard)
	
func custom_process(delta: float):
	# Block all spawning logic until start_gamemode() is called, or if the match ended.
	if !multiplayer.is_server() or !match_started: 
		return
	
	for player_id in respawn_trackers.keys():
		var tracker = respawn_trackers[player_id]
		
		if tracker["is_dead"]:
			tracker["respawn_timer"] -= delta
			if tracker["respawn_timer"] <= 0.0:
				_respawn_player(player_id)

func player_died(merc: Merc):
	if !multiplayer.is_server(): return
	var player_id = merc.name.to_int()
	
	# Update Map logic (Respawns)
	if respawn_trackers.has(player_id):
		respawn_trackers[player_id]["is_dead"] = true
		respawn_trackers[player_id]["respawn_timer"] = respawn_delay
	
	# Update Leaderboard logic
	if leaderboard:
		leaderboard.record_death(player_id)
		
	merc.queue_free()

func _respawn_player(player_id: int):
	respawn_trackers[player_id]["is_dead"] = false
	
	if leaderboard:
		leaderboard.set_player_alive(player_id)
	
	if not has_node(str(player_id)):
		var spawn_pos = Vector3.ZERO
		if spawn_points.size() > 0:
			var random_spawn = spawn_points.pick_random()
			if random_spawn:
				spawn_pos = random_spawn.position 
				
		player_spawner.spawn({
			"merc_type": "default", 
			"position": spawn_pos,
			"peer_id": player_id
		})
		print("Player ", player_id, " respawned at ", spawn_pos)

func _on_player_joined(player_id: int) -> void:
	if not multiplayer.is_server(): return
	
	respawn_trackers[player_id] = { "is_dead": true, "respawn_timer": 0.0 }
	
	if leaderboard:
		leaderboard.add_player(player_id)

func _on_player_left(player_id: int) -> void:
	if !multiplayer.is_server(): return
	
	respawn_trackers.erase(player_id)
	if leaderboard:
		leaderboard.remove_player(player_id)
	
	var merc_node = get_node_or_null(str(player_id))
	if merc_node:
		merc_node.queue_free()

func start_gamemode():
	if !multiplayer.is_server(): return
	
	# 1. Start the match and unlock spawns
	match_started = true 
	await get_tree().create_timer(gamemode_length).timeout
	
	# 2. Match time is up! Stop gameplay loops.
	match_started = false 
	
	# 3. Calculate winners and show them on all clients
	if leaderboard:
		var top_players = leaderboard.get_top_players(3)
		leaderboard.show_end_game_showcase.rpc(top_players)
		
	# 4. Wait for 10 seconds so people can see the results
	await get_tree().create_timer(10.0).timeout
	
	# 5. Finally, end the game entirely
	_game_ended()
