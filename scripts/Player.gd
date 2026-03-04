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
@onready var viewport_sprite = $Body/ViewportSprite
@onready var renderer_3d = $Body/ViewportSprite/3DCharacterViewport

var hat_bob_tween: Tween

func _ready():
	health = max_health
	add_to_group("player")

	# Initialize 3D Viewport Texture
	viewport_sprite.texture = renderer_3d.get_texture()
	renderer_3d.setup_model(load("res://assets/models/WizardModel.tscn"))

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
		viewport_sprite.rotation = lerp_angle(viewport_sprite.rotation, target_angle, 15.0 * delta)
		last_direction = look_direction

	# Animation
	if direction != Vector2.ZERO:
		if renderer_3d: renderer_3d.play_animation("walk")
	else:
		if renderer_3d: renderer_3d.play_animation("idle")

var is_spinning: bool = false

func equip_robe(robe_data: RobeData):
	current_robes.append(robe_data)

	# Spin animation on ViewportSprite node
	is_spinning = true
	var spin_tween = create_tween()
	spin_tween.tween_property(viewport_sprite, "rotation", viewport_sprite.rotation + PI * 2, 0.3)
	spin_tween.finished.connect(func(): is_spinning = false)

	# Rotate back to aim if not spinning

	# Update 3D Visuals
	if robe_data.shader_material:
		renderer_3d.set_robe_material(robe_data.shader_material)

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

	# In a real setup, we would swap 3D meshes here
	# For now we'll just apply stats

	# Stack stats
	stats.speed_multiplier += hat_data.speed_bonus
	stats.damage_multiplier += hat_data.damage_multiplier
	stats.regen_rate += hat_data.regen_bonus
	stats.multi_shot += hat_data.multi_shot_bonus

	GameManager.hat_equipped.emit(hat_data)

func take_damage(amount: float):
	health -= amount
	GameManager.player_health_changed.emit(health, max_health)
	flash_damage()
	shake_screen()
	if health <= 0:
		die()

func flash_damage():
	if renderer_3d:
		renderer_3d.flash_red()

func shake_screen():
	var cam = $CameraContainer/Camera2D
	if not cam: return
	var tween = create_tween()
	for i in range(4):
		tween.tween_property(cam, "offset", Vector2(randf_range(-5, 5), randf_range(-5, 5)), 0.05)
	tween.tween_property(cam, "offset", Vector2.ZERO, 0.05)

func die():
	get_tree().reload_current_scene()
