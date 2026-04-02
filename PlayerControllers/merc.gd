class_name Merc extends CharacterBody3D

@export var camera : Camera3D


func _ready() -> void:
	if is_multiplayer_authority():
		camera.make_current()
		print('THA BOSS')
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _enter_tree() -> void:
	# The Spawner syncs the name across the network automatically.
	# By grabbing the name and converting it back to an int, 
	# both the server and clients explicitly agree on who owns this node.
	set_multiplayer_authority(name.to_int())

func _unhandled_input(event: InputEvent) -> void:
	if !is_multiplayer_authority(): return
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
