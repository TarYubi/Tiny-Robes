extends EnemyBase

@export var shoot_range: float = 200.0
@export var projectile_scene: PackedScene
@onready var timer = $ShootTimer

func _ready():
	super._ready()
	if renderer_3d:
		renderer_3d.setup_model(load("res://assets/models/BunnyModel.tscn"))

func _physics_process(delta):
	if not player: return

	var dist = global_position.distance_to(player.global_position)
	if dist > shoot_range:
		super._physics_process(delta)
	else:
		# Stay at range and shoot
		if timer.is_stopped():
			timer.start()

func shoot():
	if not player: return
	var proj = projectile_scene.instantiate()
	proj.position = global_position
	proj.direction = (player.global_position - global_position).normalized()
	proj.damage = damage
	proj.speed = 200.0
	proj.add_to_group("enemy_projectile")
	# Change collision logic for enemy projectiles
	proj.collision_mask = 1 # Player layer
	get_tree().current_scene.add_child(proj)
