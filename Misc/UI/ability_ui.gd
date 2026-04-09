extends Control
class_name AbilitiesUI

@onready var panel: Panel = $Panel
@onready var v_box_container: VBoxContainer = $Panel/VBoxContainer

const ability_slot_scene = preload("res://Misc/UI/ability_slot_ui.tscn")

var is_menu_open: bool = false
var hidden_pos_x: float
var visible_pos_x: float

func _ready() -> void:
	await get_tree().process_frame
	
	# 1. Calculate positions for the first time
	_recalculate_positions()
	# 2. Tell Godot to run our recalculate function ANY TIME the window changes size
	#get_tree().root.size_changed.connect(_on_window_resized)
	
	# Snap the panel to the hidden position immediately on start
	panel.position.x = hidden_pos_x

# --- NEW RESIZE LOGIC ---

func _recalculate_positions() -> void:
	var screen_width = get_viewport_rect().size.x
	visible_pos_x = screen_width - panel.size.x
	hidden_pos_x = screen_width + 10

func _on_window_resized() -> void:
	# Update our target variables with the new screen size
	_recalculate_positions()
	
	# Snap the panel to its new correct position instantly
	# so it doesn't look broken while the player drags the window border
	if is_menu_open:
		panel.position.x = visible_pos_x
	else:
		panel.position.x = hidden_pos_x

# --- END NEW RESIZE LOGIC ---

func _process(_delta: float) -> void:
	var is_tab_held = Input.is_physical_key_pressed(KEY_TAB)
	
	if is_tab_held and not is_menu_open:
		_toggle_menu(true)
	elif not is_tab_held and is_menu_open:
		_toggle_menu(false)

func _toggle_menu(show: bool) -> void:
	is_menu_open = show
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	if show:
		tween.tween_property(panel, "position:x", visible_pos_x, 0.25)
	else:
		tween.tween_property(panel, "position:x", hidden_pos_x, 0.25)

func generate_ui(merc: Merc) -> void:
	for child in v_box_container.get_children():
		child.queue_free()
		
	for ability in merc.abilities:
		if ability == null: continue
		
		var slot = ability_slot_scene.instantiate()
		var name_label: RichTextLabel = slot.get_node("Ability")
		var key_label: RichTextLabel = slot.get_node("Key")
		
		name_label.text = "[center]" + str(ability.name) + "[/center]"
		key_label.text = "[center]" + str(ability.trigger_key) + "[/center]"
		
		v_box_container.add_child(slot)
