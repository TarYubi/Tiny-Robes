extends Weapon

func attack():
	# Ice shoots in 5-shot wide forward cone
	var angles = [-0.4, -0.2, 0, 0.2, 0.4] # Roughly ±20 degrees
	for angle_offset in angles:
		var proj = projectile_scene.instantiate()
		proj.position = player.global_position
		var final_angle = player.rotation + angle_offset
		proj.direction = Vector2.RIGHT.rotated(final_angle)
		proj.rotation = final_angle
		proj.damage = damage * player.stats.damage_multiplier
		proj.modulate = Color.CYAN
		get_tree().current_scene.add_child(proj)
