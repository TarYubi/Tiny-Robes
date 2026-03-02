extends Control

signal selected(data)

@onready var icon = $Panel/VBoxContainer/Icon
@onready var title_label = $Panel/VBoxContainer/Title
@onready var desc_label = $Panel/VBoxContainer/Description
@onready var border = $Panel/Border

var choice_data: Dictionary

func setup(data: Dictionary):
	choice_data = data
	title_label.text = data.get("title", "Unknown")
	desc_label.text = data.get("description", "")

	if data.has("texture"):
		icon.texture = data["texture"]

	var rarity = data.get("rarity", "common")
	match rarity:
		"common":
			border.modulate = Color.GRAY
		"rare":
			border.modulate = Color.CORNFLOWER_BLUE
		"epic":
			border.modulate = Color.MEDIUM_PURPLE
		_:
			border.modulate = Color.WHITE

	if rarity == "epic":
		# Simple glow effect using modulate tween
		var tween = create_tween().set_loops()
		tween.tween_property(border, "modulate:a", 0.5, 0.5)
		tween.tween_property(border, "modulate:a", 1.0, 0.5)

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		selected.emit(choice_data)

func _on_mouse_entered():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1).set_trans(Tween.TRANS_BACK)
	z_index = 10

func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_BACK)
	z_index = 0
