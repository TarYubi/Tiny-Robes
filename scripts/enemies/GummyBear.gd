extends EnemyBase

func _physics_process(delta):
	super._physics_process(delta)

	# Squish animation during movement
	var speed_factor = velocity.length() / speed
	if speed_factor > 0.1:
		var time = Time.get_ticks_msec() / 100.0
		$Sprite2D.scale.x = 1.0 + sin(time) * 0.2
		$Sprite2D.scale.y = 1.0 - sin(time) * 0.2
	else:
		$Sprite2D.scale = $Sprite2D.scale.lerp(Vector2.ONE, 10.0 * delta)
