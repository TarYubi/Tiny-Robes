extends EnemyBase

@export var shoot_range: float = 300.0
@export var projectile_scene: PackedScene
var shoot_timer: Timer
var start_y: float

func _ready():
	super._ready()
	start_y = global_position.y

	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.wait_time = 1.8
	shoot_timer.timeout.connect(shoot_electric_jelly)
	shoot_timer.start()

func _physics_process(delta):
	if not player: return

	# Drift logic: move towards player X, but drift Y in sine wave
	var target_x = player.global_position.x
	var dir_x = sign(target_x - global_position.x)
	velocity.x = dir_x * speed * 0.5

	# Vertical drift
	var time = Time.get_ticks_msec() / 500.0
	velocity.y = cos(time) * 100.0

	move_and_slide()

	# Tentacle "sting" animation
	$Sprite2D.scale.y = 1.0 + 0.2 * sin(time * 2.0)

func shoot_electric_jelly():
	if not player: return
	if global_position.distance_to(player.global_position) > shoot_range: return

	var proj = projectile_scene.instantiate()
	proj.position = global_position
	proj.direction = (player.global_position - global_position).normalized()
	proj.speed = 400.0 # Fast
	proj.add_to_group("enemy_projectile")
	proj.collision_mask = 1

	if proj.has_method("set_style"):
		proj.set_style("res://assets/sprites/proj_lightning.png", Color.CYAN)

	get_tree().current_scene.add_child(proj)
