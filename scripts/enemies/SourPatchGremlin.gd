extends EnemyBase

@export var projectile_scene: PackedScene
var throw_timer: Timer

func _ready():
	super._ready()
	throw_timer = Timer.new()
	add_child(throw_timer)
	throw_timer.wait_time = 3.0
	throw_timer.timeout.connect(throw_sour_bomb)
	throw_timer.start()

func throw_sour_bomb():
	if not player: return

	var proj = projectile_scene.instantiate()
	proj.position = global_position
	proj.direction = (player.global_position - global_position).normalized()
	proj.speed = 250.0
	proj.add_to_group("enemy_projectile")
	proj.add_to_group("sour_bomb") # Mark for special effect
	proj.collision_mask = 1

	if proj.has_method("set_style"):
		proj.set_style("res://assets/sprites/gumdrop.png", Color.LIME_GREEN)

	get_tree().current_scene.add_child(proj)
