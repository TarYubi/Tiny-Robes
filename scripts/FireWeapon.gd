extends Weapon

func attack():
	# Fire shoots in 3-shot forward cone
	var angles = [-0.2, 0, 0.2] # Roughly ±10 degrees
	for angle_offset in angles:
		var proj = projectile_scene.instantiate()
		proj.position = player.global_position
		var final_angle = player.viewport_sprite.rotation + angle_offset + randf_range(-0.1, 0.1)
		proj.direction = Vector2.RIGHT.rotated(final_angle)
		proj.rotation = final_angle
		proj.damage = damage * player.stats.damage_multiplier
		proj.modulate = Color.RED
		get_tree().current_scene.add_child(proj)
