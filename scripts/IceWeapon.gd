extends Weapon

func attack():
	# Ice shoots a freezing blast at the nearest enemy
	var enemies = get_tree().get_nodes_in_group("enemy")
	var nearest = null
	var min_dist = INF

	for e in enemies:
		var d = player.global_position.distance_to(e.global_position)
		if d < min_dist:
			min_dist = d
			nearest = e

	if nearest:
		var proj = projectile_scene.instantiate()
		proj.position = player.global_position
		proj.direction = (nearest.global_position - player.global_position).normalized()
		proj.damage = damage * player.stats.damage_multiplier
		proj.modulate = Color.CYAN
		get_tree().current_scene.add_child(proj)
