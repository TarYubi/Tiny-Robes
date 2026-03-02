extends Control

@onready var main_container = $MainContainer
@onready var shop_container = $ShopContainer
@onready var shop_sound = $ShopSound
@onready var upgrade_grid = $ShopContainer/UpgradeGrid
@onready var candy_label = $CandyCounter/Label

var upgrades = [
	{"id": "health_bonus", "name": "+10 Health", "cost": 50, "desc": "More heart for your wizard!"},
	{"id": "speed_bonus", "name": "+5% Speed", "cost": 75, "desc": "Zoom like a candy cane!"},
	{"id": "lucky_start", "name": "Lucky Start", "cost": 150, "desc": "Chance to start with a random robe."},
	{"id": "candy_magnet", "name": "Candy Magnet", "cost": 120, "desc": "Pull candies from farther away!"},
	{"id": "extra_life", "name": "Extra Life", "cost": 300, "desc": "Revive once with half HP."},
	{"id": "rarity_boost", "name": "Rarity Boost", "cost": 250, "desc": "Higher chance for rare/epic robes."},
	{"id": "double_candy_runs", "name": "Double Candy", "cost": 200, "desc": "Earn 2x candy for next 3 runs!"},
	{"id": "hat_slots", "name": "Hat Slot +1", "cost": 400, "desc": "Wear more hats!"},
	{"id": "unlock_fire", "name": "Fire Robe", "cost": 150, "desc": "Burn through waves of sugar!"},
	{"id": "unlock_ice", "name": "Ice Robe", "cost": 150, "desc": "Freeze your gummy foes."},
	{"id": "unlock_lightning", "name": "Lightning Robe", "cost": 200, "desc": "Zap them with sour power!"},
	{"id": "unlock_thorn", "name": "Thorn Robe", "cost": 200, "desc": "Prickly protection!"},
	{"id": "unlock_multi_top", "name": "Top Hat", "cost": 150, "desc": "Shoot multiple projects!"},
	{"id": "unlock_power_crown", "name": "Power Crown", "cost": 200, "desc": "Royal damage boost!"},
	{"id": "unlock_regen_beanie", "name": "Regen Beanie", "cost": 180, "desc": "Healthy candy vibes."},
	{"id": "unlock_speed_cap", "name": "Speed Cap", "cost": 150, "desc": "Quick like a bunny!"}
]

func _ready():
	show_main_menu()
	update_candy_display()
	setup_shop()

func update_candy_display():
	var current = SaveManager.user_data.candy_count
	if candy_label.text != "Candies: " + str(current):
		animate_candy_change(current)
	candy_label.text = "Candies: " + str(current)

func animate_candy_change(new_value):
	var tween = create_tween()
	tween.tween_property(candy_label, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(candy_label, "scale", Vector2.ONE, 0.1)

	# Mini candy rain effect could go here with particles if we had a candy texture
	# For now just the pop scale effect

func setup_shop():
	for child in upgrade_grid.get_children():
		child.queue_free()

	for upgrade in upgrades:
		var panel = Panel.new()
		panel.custom_minimum_size = Vector2(180, 150)
		panel.modulate = Color(1, 0.82, 0.86, 1) # Pastel pink

		var vbox = VBoxContainer.new()
		vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 10)
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox.add_theme_constant_override("separation", 5)
		panel.add_child(vbox)

		var name_label = Label.new()
		name_label.text = upgrade.name
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.add_theme_color_override("font_color", Color(0.9, 0.2, 0.5, 1))
		vbox.add_child(name_label)

		var desc_label = Label.new()
		desc_label.text = upgrade.desc
		desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_label.add_theme_font_size_override("font_size", 10)
		desc_label.add_theme_color_override("font_color", Color(0.6, 0.2, 0.4, 1))
		vbox.add_child(desc_label)

		var buy_btn = Button.new()
		buy_btn.text = str(upgrade.cost) + " 🍬"

		# Check if maxed (simple limit for now)
		var current_lvl = SaveManager.user_data.purchased_upgrades.get(upgrade.id, 0)
		if upgrade.id.begins_with("unlock_"):
			var item_id = upgrade.id.replace("unlock_", "")
			if SaveManager.user_data.unlocked_robes.has(item_id) or SaveManager.user_data.unlocked_hats.has(item_id):
				buy_btn.text = "UNLOCKED"
				buy_btn.disabled = true
		elif current_lvl >= 5: # Max level 5 for now
			buy_btn.text = "MAXED OUT"
			buy_btn.disabled = true

		buy_btn.pressed.connect(_on_upgrade_purchased.bind(upgrade, buy_btn))
		vbox.add_child(buy_btn)

		upgrade_grid.add_child(panel)

func _on_upgrade_purchased(upgrade, btn):
	if SaveManager.spend_candy(upgrade.cost):
		if upgrade.id == "double_candy_runs":
			SaveManager.user_data.purchased_upgrades["double_candy_runs"] += 3
		elif upgrade.id.begins_with("unlock_"):
			var item_id = upgrade.id.replace("unlock_", "")
			if upgrade.name.contains("Robe"):
				if not SaveManager.user_data.unlocked_robes.has(item_id):
					SaveManager.user_data.unlocked_robes.append(item_id)
			else:
				if not SaveManager.user_data.unlocked_hats.has(item_id):
					SaveManager.user_data.unlocked_hats.append(item_id)
		elif upgrade.id in SaveManager.user_data.purchased_upgrades:
			SaveManager.user_data.purchased_upgrades[upgrade.id] += 1
		else:
			SaveManager.user_data.purchased_upgrades[upgrade.id] = 1
		SaveManager.save_game()
		update_candy_display()

		# Update button state
		var current_lvl = SaveManager.user_data.purchased_upgrades.get(upgrade.id, 0)
		if upgrade.id == "double_candy_runs":
			btn.text = str(upgrade.cost) + " 🍬 (" + str(current_lvl) + " runs)"
		elif upgrade.id.begins_with("unlock_"):
			btn.text = "UNLOCKED"
			btn.disabled = true
		elif current_lvl >= 5:
			btn.text = "MAXED OUT"
			btn.disabled = true

		if shop_sound.stream:
			shop_sound.play()

		# Visual feedback: Simple confetti burst on purchase
		var confetti = CPUParticles2D.new()
		confetti.position = btn.global_position + (btn.size / 2)
		confetti.emitting = true
		confetti.amount = 20
		confetti.one_shot = true
		confetti.explosiveness = 1.0
		confetti.spread = 180.0
		confetti.gravity = Vector2(0, 100)
		confetti.initial_velocity_min = 50.0
		confetti.initial_velocity_max = 100.0
		confetti.color = Color.PINK
		add_child(confetti)

		# Auto-free after 2 seconds
		get_tree().create_timer(2.0).timeout.connect(confetti.queue_free)

		print("Purchased: ", upgrade.name)

func show_main_menu():
	main_container.visible = true
	shop_container.visible = false

func show_shop():
	main_container.visible = false
	shop_container.visible = true

func _on_play_pressed():
	GameManager.start_run()
	get_tree().change_scene_to_file("res://scenes/Level/ArenaLevel.tscn")

func _on_shop_pressed():
	show_shop()

func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	show_main_menu()
