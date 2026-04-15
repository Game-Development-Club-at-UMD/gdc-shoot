extends Area3D

@onready var scream = $AudioStreamPlayer3D

var mercs_in_box = []
@export var damage = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for m in mercs_in_box:
		if !m:
			mercs_in_box.erase(m)
			scream.play()
			pass
		m.take_damage.rpc_id(m.name.to_int(), damage) 

func _on_body_entered(body: Node3D) -> void:
	mercs_in_box.append(body)

func _on_body_exited(body: Node3D) -> void:
	mercs_in_box.erase(body)
