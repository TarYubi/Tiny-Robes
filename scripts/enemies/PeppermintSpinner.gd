extends EnemyBase

@export var projectile_scene: PackedScene
var shoot_timer: Timer
var angle: float = 0.0

func _ready():
	super._ready()
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.wait_time = 1.2
	shoot_timer.timeout.connect(shoot_cross)
	shoot_timer.start()

func _physics_process(delta):
	# Spin fast in circles
	angle += 5.0 * delta
	var radius = 50.0
	var target_pos = player.global_position if player else global_position
	var circle_offset = Vector2(cos(angle), sin(angle)) * radius

	var target_dir = (target_pos + circle_offset - global_position).normalized()
	velocity = target_dir * speed * 1.5
	move_and_slide()

	$Sprite2D.rotation += 15.0 * delta

func shoot_cross():
	for i in range(4):
		var proj = projectile_scene.instantiate()
		proj.position = global_position
		var shoot_dir = Vector2.RIGHT.rotated(i * PI/2 + $Sprite2D.rotation)
		proj.direction = shoot_dir
		proj.speed = 200.0
		proj.add_to_group("enemy_projectile")
		proj.collision_mask = 1

		if proj.has_method("set_style"):
			proj.set_style("res://assets/sprites/candy_cane.png", Color.RED)
			proj.rotation = shoot_dir.angle() + PI/4

		get_tree().current_scene.add_child(proj)
