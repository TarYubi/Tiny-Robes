extends SubViewport

@onready var model_root = $Node3D/ModelRoot
@onready var anim_player = $Node3D/AnimationPlayer

func setup_model(model_scene: PackedScene):
	for child in model_root.get_children():
		child.queue_free()

	if model_scene:
		var model = model_scene.instantiate()
		model_root.add_child(model)

func _process(_delta):
	# Call update for procedural animations if no active AnimationPlayer animation
	if not anim_player.is_playing():
		pass # We'll handle it inside play_animation call or continuous update

func play_animation(anim_name: String):
	if anim_player.has_animation(anim_name):
		anim_player.play(anim_name)
	else:
		# Simple procedural fallback
		match anim_name:
			"walk":
				var time = Time.get_ticks_msec() / 150.0
				model_root.position.y = abs(sin(time)) * 0.1
				model_root.rotation.z = sin(time) * 0.05
			"idle":
				var time = Time.get_ticks_msec() / 500.0
				model_root.position.y = sin(time) * 0.02
				model_root.rotation.z = 0

func set_robe_material(material: Material):
	# Traverse children to find robe mesh and apply material
	_apply_material_recursive(model_root, material, "robe")

func flash_red():
	var tween = create_tween()
	_apply_color_recursive(model_root, Color.RED)
	tween.tween_callback(func(): _apply_color_recursive(model_root, Color.WHITE)).set_delay(0.2)

func _apply_color_recursive(node: Node, color: Color):
	if node is MeshInstance3D:
		node.set_instance_shader_parameter("modulate_color", color)
		# Ensure material is unique to this instance
		var mat = node.get_surface_override_material(0)
		if mat:
			mat = mat.duplicate()
			node.set_surface_override_material(0, mat)
			if mat is StandardMaterial3D:
				mat.albedo_color = color
	for child in node.get_children():
		_apply_color_recursive(child, color)

func set_hat_mesh(hat_scene: PackedScene):
	# Find hat attachment point and instance hat
	var hat_point = _find_node_recursive(model_root, "HatPoint")
	if hat_point:
		for child in hat_point.get_children():
			child.queue_free()
		if hat_scene:
			var hat = hat_scene.instantiate()
			hat_point.add_child(hat)

func _apply_material_recursive(node: Node, material: Material, keyword: String):
	if node is MeshInstance3D and keyword in node.name.to_lower():
		node.set_surface_override_material(0, material)
	for child in node.get_children():
		_apply_material_recursive(child, material, keyword)

func _find_node_recursive(node: Node, node_name: String) -> Node:
	if node.name == node_name:
		return node
	for child in node.get_children():
		var found = _find_node_recursive(child, node_name)
		if found:
			return found
	return null
