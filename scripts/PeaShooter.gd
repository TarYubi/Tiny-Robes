extends Weapon

func attack():
	var proj = projectile_scene.instantiate()
	proj.position = player.global_position

	# Peas shoot in facing direction
	var dir = Vector2.RIGHT.rotated(player.viewport_sprite.rotation)

	proj.direction = dir
	proj.rotation = player.viewport_sprite.rotation
	proj.damage = damage * player.stats.damage_multiplier
	proj.speed = projectile_speed

	get_tree().current_scene.add_child(proj)
