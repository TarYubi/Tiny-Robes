extends Node

signal fullscreen_toggled(is_fullscreen: bool)

const SAVE_PATH = "user://settings.cfg"
var config = ConfigFile.new()

func _ready():
	load_settings()

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		toggle_fullscreen()
<<<<<<< HEAD

	if OS.is_debug_build() and event is InputEventKey and event.pressed and event.keycode == KEY_L:
		GameManager.wave_completed.emit(-1) # Debug wave

	if OS.is_debug_build() and event is InputEventKey and event.pressed and event.keycode == KEY_C:
		SaveManager.add_candy(1000)
=======
>>>>>>> origin/luna-premium-robes-layers-shaders-10532435458121204687

func toggle_fullscreen():
	var current_mode = DisplayServer.window_get_mode()
	var is_fullscreen = current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN

	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	var new_state = not is_fullscreen
	save_settings(new_state)
	fullscreen_toggled.emit(new_state)

func save_settings(is_fullscreen: bool):
	config.set_value("video", "fullscreen", is_fullscreen)
	config.save(SAVE_PATH)

func load_settings():
	var err = config.load(SAVE_PATH)
	if err == OK:
		var is_fullscreen = config.get_value("video", "fullscreen", false)
		if is_fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			fullscreen_toggled.emit(true)
