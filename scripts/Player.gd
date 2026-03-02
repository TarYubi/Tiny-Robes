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

@onready var anim_player = $AnimationPlayer
@onready var weapon_container = $Weapons

# Visual Nodes
@onready var body_node = $Body
@onready var body_base = $Body/Base
@onready var robe_base = $Body/RobeBase
@onready var robe_trim = $Body/RobeTrim
@onready var sleeves = $Body/Sleeves
@onready var hat_sprite = $Body/HatSprite
@onready var hat_detail = $Body/HatDetail
@onready var shine_overlay = $Body/ShineOverlay

var hat_bob_tween: Tween

func _ready():
	apply_meta_upgrades()
	health = max_health
	add_to_group("player")

	# Start in underwear
	body_base.texture = load("res://assets/sprites/player/chibi_walk.png")

	# Hide robe layers
	robe_base.visible = false
	robe_trim.visible = false
	sleeves.visible = false
	hat_sprite.visible = false
	hat_detail.visible = false
	shine_overlay.visible = false

	# Start with basic pea shooter
	var pea_shooter_scene = load("res://scenes/Weapons/PeaShooter.tscn")
	if pea_shooter_scene:
		var pea_shooter = pea_shooter_scene.instantiate()
		weapon_container.add_child(pea_shooter)

func _physics_process(delta):
	# Movement
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * base_speed * stats.speed_multiplier
	move_and_slide()

	# Rotation (Mouse / Controller)
	var look_direction = Vector2.ZERO
	var joy_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if joy_dir.length() > 0.1:
		look_direction = joy_dir
	else:
		look_direction = (get_global_mouse_position() - global_position).normalized()

	if look_direction != Vector2.ZERO and not is_spinning:
		var target_angle = look_direction.angle()
		rotation = lerp_angle(rotation, target_angle, 15.0 * delta)
		last_direction = look_direction

	# Animation
	if direction != Vector2.ZERO:
		anim_player.play("walk")
	else:
		anim_player.play("idle")

var is_spinning: bool = false

func equip_robe(robe_data: RobeData):
	current_robes.append(robe_data)

	# Spin animation on Body node only to avoid affecting weapon rotation
	is_spinning = true
	var spin_tween = create_tween()
	spin_tween.tween_property(body_node, "rotation", body_node.rotation + PI * 2, 0.3)
	spin_tween.finished.connect(func(): is_spinning = false)

	# Update visuals
	if robe_data.base_texture:
		robe_base.texture = robe_data.base_texture
		robe_base.visible = true
		shine_overlay.texture = robe_data.base_texture

	if robe_data.trim_texture:
		robe_trim.texture = robe_data.trim_texture
		robe_trim.visible = true
		robe_trim.material = robe_data.shader_material

	if robe_data.sleeves_texture:
		sleeves.texture = robe_data.sleeves_texture
		sleeves.visible = true
		sleeves.material = robe_data.shader_material

	# Trigger shine effect via Tween to avoid AnimationPlayer conflicts
	shine_overlay.visible = true
	var mat = shine_overlay.material as ShaderMaterial
	if mat:
		var shine_tween = create_tween()
		shine_tween.tween_property(mat, "shader_parameter/shine_progress", 1.0, 0.6).from(0.0)
		shine_tween.finished.connect(func(): shine_overlay.visible = false)

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
	if hat_data.hat_texture:
		hat_sprite.texture = hat_data.hat_texture

	if hat_data.detail_texture:
		hat_detail.texture = hat_data.detail_texture
		hat_detail.visible = true

	# Stack stats
	stats.speed_multiplier += hat_data.speed_bonus
	stats.damage_multiplier += hat_data.damage_multiplier
	stats.regen_rate += hat_data.regen_bonus
	stats.multi_shot += hat_data.multi_shot_bonus

	# Bobbing animation - Kill previous to avoid leak
	if hat_bob_tween:
		hat_bob_tween.kill()

	hat_bob_tween = create_tween().set_loops()
	var start_pos = Vector2(0, -16)
	hat_bob_tween.tween_property(hat_sprite, "position", start_pos + Vector2(0, -hat_data.bob_amplitude), 1.0 / hat_data.bob_speed).set_trans(Tween.TRANS_SINE)
	hat_bob_tween.tween_property(hat_sprite, "position", start_pos, 1.0 / hat_data.bob_speed).set_trans(Tween.TRANS_SINE)

	# Sync hat detail to same bobbing
	var detail_tween = create_tween().set_loops()
	detail_tween.tween_property(hat_detail, "position", start_pos + Vector2(0, -hat_data.bob_amplitude), 1.0 / hat_data.bob_speed).set_trans(Tween.TRANS_SINE)
	detail_tween.tween_property(hat_detail, "position", start_pos, 1.0 / hat_data.bob_speed).set_trans(Tween.TRANS_SINE)
	hat_bob_tween.finished.connect(func(): detail_tween.kill()) # Cleanup if main stops

	GameManager.hat_equipped.emit(hat_data)

func take_damage(amount: float):
	health -= amount
	GameManager.player_health_changed.emit(health, max_health)
	flash_damage()
	shake_screen()
	if health <= 0:
		die()

func flash_damage():
	var tween = create_tween()
	var parts = [body_base, robe_base, robe_trim, sleeves]
	for part in parts:
		part.modulate = Color.RED
	tween.tween_property(body_base, "modulate", Color.WHITE, 0.2)
	tween.finished.connect(func():
		for part in parts: part.modulate = Color.WHITE
	)

func shake_screen():
	var cam = $Camera2D
	if not cam: return
	var tween = create_tween()
	for i in range(4):
		tween.tween_property(cam, "offset", Vector2(randf_range(-5, 5), randf_range(-5, 5)), 0.05)
	tween.tween_property(cam, "offset", Vector2.ZERO, 0.05)

func apply_meta_upgrades():
	var meta = SaveManager.user_data.purchased_upgrades
	if meta.has("health_bonus"):
		max_health += meta["health_bonus"] * 10
	if meta.has("speed_bonus"):
		stats.speed_multiplier += meta["speed_bonus"] * 0.05

	if meta.get("candy_magnet", 0) > 0:
		# Assume there's a pickup radius property or similar
		# If not, we'll note it as a stat for future use
		stats["pickup_radius_multiplier"] = 1.0 + (meta["candy_magnet"] * 0.2)

	if meta.get("lucky_start", 0) > 0:
		# 20% per level chance
		if randf() < (meta["lucky_start"] * 0.2):
			var unlocked_robes = SaveManager.user_data.unlocked_robes
			if unlocked_robes.size() > 0:
				var robe_id = unlocked_robes.pick_random()
				var robe_path = "res://resources/robes/" + robe_id + "_robe.tres"
				if ResourceLoader.exists(robe_path):
					equip_robe(load(robe_path))

func die():
	get_tree().reload_current_scene()
