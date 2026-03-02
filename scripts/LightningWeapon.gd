extends Weapon

func attack():
	# Lightning shoots forward and bounces
	var proj = projectile_scene.instantiate()
	proj.position = player.global_position
	proj.direction = Vector2.RIGHT.rotated(player.rotation)
	proj.rotation = player.rotation
	proj.damage = damage * player.stats.damage_multiplier
	proj.modulate = Color.YELLOW
	proj.speed *= 1.5
	proj.add_to_group("bouncing") # Mark for script
	get_tree().current_scene.add_child(proj)
