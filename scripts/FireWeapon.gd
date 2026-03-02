extends Weapon

func attack():
	# Fire shoots in 3-shot forward cone
	var angles = [-0.2, 0, 0.2] # Roughly ±10 degrees
	for angle_offset in angles:
		var proj = projectile_scene.instantiate()
		proj.position = player.global_position
		var final_angle = player.rotation + angle_offset + randf_range(-0.1, 0.1)
		proj.direction = Vector2.RIGHT.rotated(final_angle)
		proj.rotation = final_angle
		proj.damage = damage * player.stats.damage_multiplier
<<<<<<< HEAD
		proj.set_style("res://assets/sprites/proj_fire.png", Color.ORANGE_RED)
=======
		proj.modulate = Color.RED
>>>>>>> origin/luna-premium-robes-layers-shaders-10532435458121204687
		get_tree().current_scene.add_child(proj)
