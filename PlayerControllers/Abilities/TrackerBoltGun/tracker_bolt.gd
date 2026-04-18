extends Node3D

@onready var duration_timer = $Timer
@onready var bleed_timer = $BleedTimer

@onready var tracker
@onready var target_player = get_parent()

func _ready() -> void:
	$Sprite3D.visible = false
	if !tracker: return
	$Sprite3D.visible = true

func _on_bleed_timer_timeout() -> void:
	if target_player is Merc or target_player is DestructibleProp:
		target_player.health -= 5


func _on_timer_timeout() -> void:
	queue_free()
