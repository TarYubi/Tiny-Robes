extends Weapon

func attack():
	var proj = projectile_scene.instantiate()
	proj.position = player.global_position

	# Peas shoot in facing direction
	var dir = Vector2.RIGHT.rotated(player.rotation)

	proj.direction = dir
	proj.rotation = player.rotation
	proj.damage = damage * player.stats.damage_multiplier
	proj.speed = projectile_speed

	# Default sugar cube projectile
	proj.set_style("res://assets/sprites/sugar_cube.png", Color.WHITE)

	get_tree().current_scene.add_child(proj)
