extends EnemyBase

@export var shoot_range: float = 200.0
@export var projectile_scene: PackedScene
@onready var timer = $ShootTimer

func _physics_process(delta):
	if not player: return

	var dist = global_position.distance_to(player.global_position)
	if dist > shoot_range:
		super._physics_process(delta)
		# Calm down blush
		$Sprite2D.modulate = $Sprite2D.modulate.lerp(Color.WHITE, 5.0 * delta)
	else:
		# Stay at range and shoot
		if timer.is_stopped():
			timer.start()

		# Angry blush when about to shoot
		var blush_factor = 1.0 - (timer.time_left / timer.wait_time)
		$Sprite2D.modulate = Color.WHITE.lerp(Color(1, 0.6, 0.6), blush_factor)

func shoot():
	if not player: return

	# Jump back when shooting
	var jump_dir = (global_position - player.global_position).normalized()
	global_position += jump_dir * 20.0

	var proj = projectile_scene.instantiate()
	proj.position = global_position
	proj.direction = (player.global_position - global_position).normalized()
	proj.damage = damage
	proj.speed = 250.0
	proj.add_to_group("enemy_projectile")
	# Change collision logic for enemy projectiles
	proj.collision_mask = 1 # Player layer

	# Carrot texture
	if proj.has_node("Sprite2D"):
		proj.get_node("Sprite2D").texture = load("res://assets/sprites/carrot.png")
		proj.rotation = proj.direction.angle() + PI/2

	get_tree().current_scene.add_child(proj)
