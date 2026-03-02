extends Weapon

func attack():
	var proj = projectile_scene.instantiate()
	proj.position = player.global_position

	# Peas shoot in movement direction or forward if standing still
	var dir = player.last_direction
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT

	proj.direction = dir
	proj.damage = damage * player.stats.damage_multiplier
	proj.speed = projectile_speed

	get_tree().current_scene.add_child(proj)
