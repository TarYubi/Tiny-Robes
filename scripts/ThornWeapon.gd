extends Weapon

func attack():
	# Thorn shoots in a circle around the player
	var count = 8
	for i in range(count):
		var angle = i * (PI * 2 / count)
		var dir = Vector2.RIGHT.rotated(angle)
		var proj = projectile_scene.instantiate()
		proj.position = player.global_position
		proj.direction = dir
		proj.damage = damage * player.stats.damage_multiplier
		proj.modulate = Color.GREEN
		get_tree().current_scene.add_child(proj)
