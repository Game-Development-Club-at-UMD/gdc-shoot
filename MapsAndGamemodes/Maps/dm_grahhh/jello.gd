extends CSGMesh3D

@export var damage = 1000
@onready var audio = $AudioStreamPlayer3D
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Merc:
		audio.play()
		body.take_damage.rpc_id(body.name.to_int(), damage) 
