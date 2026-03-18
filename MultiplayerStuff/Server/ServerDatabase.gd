extends Node
#and manager ;)
#if i wanted permanent stuff, look into just a simple cfg file for the future

#region DataBase
var playerDict : Dictionary [int, Dictionary] 
#var chat 


#endregion

#region Manager
func add_player(peer_id : int):
	playerDict[peer_id] = {}

func remove_player(peer_id : int):
	playerDict.erase(peer_id)
	
#endregion
