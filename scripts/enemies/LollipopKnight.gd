extends EnemyBase

var is_twirling: bool = false
@onready var original_scale = $Sprite2D.scale

func _ready():
	super._ready()
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 3.0
	timer.timeout.connect(_start_twirl)
	timer.start()

func _physics_process(delta):
	if is_twirling:
		$Sprite2D.rotation += 25.0 * delta
		# Visual feedback for area attack
		$Sprite2D.scale = original_scale * 1.3
		# Add a rainbow-ish modulate effect during twirl
		var h = wrapf(Time.get_ticks_msec() / 200.0, 0, 1)
		$Sprite2D.modulate = Color.from_hsv(h, 0.6, 1.0)

		# Simple area damage logic
		if player and global_position.distance_to(player.global_position) < 60.0:
			player.take_damage(damage * delta * 5.0)
	else:
		super._physics_process(delta)
		$Sprite2D.scale = $Sprite2D.scale.lerp(original_scale, 5.0 * delta)
		$Sprite2D.modulate = $Sprite2D.modulate.lerp(Color.WHITE, 5.0 * delta)

func _start_twirl():
	is_twirling = true
	await get_tree().create_timer(1.0).timeout
	is_twirling = false
	$Sprite2D.rotation = 0
