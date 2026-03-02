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
		buy_btn.pressed.connect(_on_upgrade_purchased.bind(upgrade))
		vbox.add_child(buy_btn)

		upgrade_grid.add_child(panel)

func _on_upgrade_purchased(upgrade):
	if SaveManager.spend_candy(upgrade.cost):
		if upgrade.id.begins_with("unlock_"):
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
		if shop_sound.stream:
			shop_sound.play()
		# Add a visual feedback
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
