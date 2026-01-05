extends Node3D 
class_name Level

@export var player_spawn : Node3D

func _ready() -> void:
	if multiplayer.is_server(): return
