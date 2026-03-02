extends CharacterBody2D

@export var base_speed: float = 200.0
@export var max_health: float = 100.0

var health: float
var last_direction: Vector2 = Vector2.RIGHT

# Stats container
var stats = {
	"speed_multiplier": 1.0,
	"damage_multiplier": 1.0,
	"fire_rate_multiplier": 1.0,
	"regen_rate": 0.0,
	"multi_shot": 0
}

var current_robes = []
var hat_count: int = 0
var base_hat_color: Color = Color.WHITE

@onready var sprite = $Body/Sprite2D
@onready var hat_sprite = $Body/HatSprite
@onready var sleeve_l = $Body/SleeveL
@onready var sleeve_r = $Body/SleeveR
@onready var anim_player = $AnimationPlayer
@onready var weapon_container = $Weapons

func _ready():
	health = max_health
	add_to_group("player")
	# Start with basic underwear
	sprite.texture = load("res://assets/sprites/player_underwear.png")
	hat_sprite.visible = false

	# Start with basic pea shooter
	var pea_shooter_scene = load("res://scenes/Weapons/PeaShooter.tscn")
	if pea_shooter_scene:
		var pea_shooter = pea_shooter_scene.instantiate()
		weapon_container.add_child(pea_shooter)

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * base_speed * stats.speed_multiplier
	move_and_slide()

	if direction != Vector2.ZERO:
		last_direction = direction
		$Body.scale.x = -1 if direction.x < 0 else 1
		anim_player.play("walk")
	else:
		anim_player.play("idle")

func equip_robe(robe_data: RobeData):
	current_robes.append(robe_data)

	# Update visuals to the latest robe
	# REPLACE WITH REAL PIXEL ART HERE
	sprite.texture = robe_data.sprite_texture
	sleeve_l.visible = true
	sleeve_r.visible = true
	sleeve_l.modulate = Color(1, 1, 1, 0.8) # Slight difference
	sleeve_r.modulate = Color(1, 1, 1, 0.8)

	# Apply stats
	stats.damage_multiplier *= robe_data.damage_multiplier
	stats.fire_rate_multiplier *= robe_data.fire_rate_multiplier
	stats.speed_multiplier += robe_data.speed_bonus

	# Add weapon
	if robe_data.weapon_scene:
		var weapon = robe_data.weapon_scene.instantiate()
		weapon_container.add_child(weapon)

	GameManager.robe_equipped.emit(robe_data)

func equip_hat(hat_data: HatData):
	hat_count += 1
	hat_sprite.visible = true
	# REPLACE WITH REAL PIXEL ART HERE
	if hat_data.sprite_texture:
		hat_sprite.texture = hat_data.sprite_texture

	# Stack stats
	stats.speed_multiplier += hat_data.speed_bonus
	stats.damage_multiplier += hat_data.damage_multiplier
	stats.regen_rate += hat_data.regen_bonus
	stats.multi_shot += hat_data.multi_shot_bonus

	# Update hat color based on count
	# We'll use a simple hue shift or multiply
	hat_sprite.self_modulate = hat_data.base_color.darkened(0.1 * (hat_count - 1))

	GameManager.hat_equipped.emit(hat_data)

func take_damage(amount: float):
	health -= amount
	GameManager.player_health_changed.emit(health, max_health)

	# Damage flash and screen shake
	flash_damage()
	shake_screen()

	if health <= 0:
		die()

func flash_damage():
	var tween = create_tween()
	sprite.modulate = Color.RED
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.2)

func shake_screen():
	# Simple camera shake
	var cam = $Camera2D
	var tween = create_tween()
	for i in range(4):
		tween.tween_property(cam, "offset", Vector2(randf_range(-5, 5), randf_range(-5, 5)), 0.05)
	tween.tween_property(cam, "offset", Vector2.ZERO, 0.05)

func die():
	# For now just reload
	get_tree().reload_current_scene()
