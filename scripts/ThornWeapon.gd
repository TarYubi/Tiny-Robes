extends Weapon

func attack():
	# Thorn launches spinning thorns forward with slight homing
	var proj = projectile_scene.instantiate()
	proj.position = player.global_position
	proj.direction = Vector2.RIGHT.rotated(player.viewport_sprite.rotation)
	proj.rotation = player.viewport_sprite.rotation
	proj.damage = damage * player.stats.damage_multiplier
	proj.modulate = Color.GREEN
	proj.add_to_group("homing") # Mark for script to handle
	get_tree().current_scene.add_child(proj)
