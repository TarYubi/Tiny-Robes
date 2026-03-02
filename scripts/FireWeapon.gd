extends Weapon

func attack():
	# Fire shoots in 4 cardinal directions
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	for dir in directions:
		var proj = projectile_scene.instantiate()
		proj.position = player.global_position
		proj.direction = dir
		proj.damage = damage * player.stats.damage_multiplier
		proj.modulate = Color.RED
		get_tree().current_scene.add_child(proj)
