extends CanvasLayer

@onready var health_bar = $Control/HealthBar
@onready var heart_icon = $Control/HeartIcon
@onready var score_label = $Control/ScoreLabel
@onready var candy_label = $Control/CandyLabel
@onready var message_label = $Control/MessageLabel
@onready var aim_indicator = $Control/AimIndicator
@onready var fs_button = $Control/FullscreenButton

func _ready():
	GameManager.player_health_changed.connect(_on_health_changed)
	GameManager.player_leveled_up.connect(_on_wave_started)
	InputHandler.fullscreen_toggled.connect(_on_fs_toggled)
	fs_button.pressed.connect(InputHandler.toggle_fullscreen)
	message_label.text = "Welcome to RobeSurvivors!"
	var timer = get_tree().create_timer(3.0)
	timer.timeout.connect(func(): message_label.text = "")

func _process(_delta):
	score_label.text = "Score: %d" % GameManager.current_score
	candy_label.text = "Candy: %d" % SaveManager.user_data.candy_count

	var player = get_tree().get_first_node_in_group("player")
	if player:
		aim_indicator.rotation = player.rotation

func _on_health_changed(current, max_h):
	health_bar.value = (current / max_h) * 100
	# Pulsing heart icon on health change
	var tween = create_tween()
	tween.tween_property(heart_icon, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(heart_icon, "scale", Vector2.ONE, 0.1)

func _on_fs_toggled(is_fs: bool):
	fs_button.text = "W" if is_fs else "⛶"

func _on_wave_started(wave_num):
	message_label.text = "Wave %d Started!" % wave_num
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(func(): if message_label.text.begins_with("Wave"): message_label.text = "")
