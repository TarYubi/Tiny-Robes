extends EnemyBase

@export var shoot_range: float = 250.0
@export var projectile_scene: PackedScene
var shoot_timer: Timer

func _ready():
	super._ready()
	# Phase through walls: remove layer 3 (environment) from collision mask
	set_collision_mask_value(3, false)

	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.wait_time = 2.5
	shoot_timer.timeout.connect(shoot_marshmallow)
	shoot_timer.start()

func _physics_process(delta):
	if not player: return

	# Slow floaty movement
	var dir = (player.global_position - global_position).normalized()
	velocity = dir * speed * (0.8 + 0.2 * sin(Time.get_ticks_msec() / 200.0))
	move_and_slide()

	# Transparency pulse
	$Sprite2D.modulate.a = 0.6 + 0.2 * cos(Time.get_ticks_msec() / 300.0)

func shoot_marshmallow():
	if not player: return
	if global_position.distance_to(player.global_position) > shoot_range: return

	var proj = projectile_scene.instantiate()
	proj.position = global_position
	proj.direction = (player.global_position - global_position).normalized()
	proj.speed = 150.0
	proj.add_to_group("enemy_projectile")
	proj.add_to_group("bouncing")
	proj.collision_mask = 1 | 4 # Player and Walls (so it bounces off walls)

	if proj.has_method("set_style"):
		proj.set_style("res://assets/sprites/sugar_cube.png", Color.WHITE)

	get_tree().current_scene.add_child(proj)
