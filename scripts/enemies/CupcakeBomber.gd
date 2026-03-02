extends EnemyBase

func die():
	# Extra juice for the bomber
	spawn_explosion_effect()
	# Damage player if close
	if player and global_position.distance_to(player.global_position) < 80.0:
		player.take_damage(damage * 2.0)
	super.die()

func spawn_explosion_effect():
	var effect_scene = load("res://scenes/Effects/DeathParticles.tscn")
	if effect_scene:
		var effect = effect_scene.instantiate()
		effect.position = global_position
		effect.amount = 100
		effect.process_material.color = Color(1, 0.8, 0.9) # Frosting color
		effect.process_material.initial_velocity_min = 200
		effect.process_material.initial_velocity_max = 400
		get_tree().current_scene.add_child(effect)
		effect.emitting = true
