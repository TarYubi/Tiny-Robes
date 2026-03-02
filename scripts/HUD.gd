extends CanvasLayer

@onready var health_bar = $Control/HealthBar
@onready var score_label = $Control/ScoreLabel
@onready var message_label = $Control/MessageLabel
@onready var level_up_menu = $Control/LevelUpMenu
@onready var upgrade_button = $Control/LevelUpMenu/VBoxContainer/Option1
@onready var hat_button = $Control/LevelUpMenu/VBoxContainer/Option2

func _ready():
	GameManager.player_health_changed.connect(_on_health_changed)
	GameManager.player_leveled_up.connect(_on_wave_started)
	message_label.text = "Welcome to RobeSurvivors!"
	var timer = get_tree().create_timer(3.0)
	timer.timeout.connect(func(): message_label.text = "")

func _process(_delta):
	score_label.text = "Score: %d" % GameManager.current_score

func _on_health_changed(current, max_h):
	health_bar.value = (current / max_h) * 100

func _on_wave_started(wave_num):
	message_label.text = "Wave %d Started!" % wave_num
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(func(): if message_label.text.begins_with("Wave"): message_label.text = "")

	if wave_num > 1:
		show_level_up()

func show_level_up():
	level_up_menu.visible = true
	get_tree().paused = true
	# Setup buttons
	if not upgrade_button.pressed.is_connected(_on_upgrade_selected):
		upgrade_button.pressed.connect(_on_upgrade_selected)
	if not hat_button.pressed.is_connected(_on_hat_selected):
		hat_button.pressed.connect(_on_hat_selected)

func _on_upgrade_selected():
	hide_level_up()

func _on_hat_selected():
	hide_level_up()

func hide_level_up():
	level_up_menu.visible = false
	get_tree().paused = false
