extends Weapon

func attack():
	# Lightning shoots at a random enemy in range
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.is_empty(): return

	var target = enemies.pick_random()
	if player.global_position.distance_to(target.global_position) < 400:
		var proj = projectile_scene.instantiate()
		proj.position = player.global_position
		proj.direction = (target.global_position - player.global_position).normalized()
		proj.damage = damage * player.stats.damage_multiplier
		proj.modulate = Color.YELLOW
		proj.speed *= 1.5
		get_tree().current_scene.add_child(proj)
