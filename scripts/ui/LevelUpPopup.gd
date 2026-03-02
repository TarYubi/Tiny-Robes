extends CanvasLayer

@onready var card_container = $Control/CardContainer
@onready var choice_sound = $ChoiceSound
@onready var confetti = $Confetti
@onready var reroll_button = $Control/RerollButton
@onready var choice_card_scene = preload("res://scenes/UI/ChoiceCard.tscn")

var all_robes = []
var all_hats = []

func _init():
	load_resources()

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	add_to_group("level_up_popup")
	GameManager.wave_completed.connect(func(_wave): show_popup())

func load_resources():
	var robe_paths = [
		"res://resources/robes/fire_robe.tres",
		"res://resources/robes/frost_robe.tres",
		"res://resources/robes/thunder_robe.tres",
		"res://resources/robes/nature_robe.tres",
		"res://resources/robes/arcane_robe.tres",
		"res://resources/robes/void_robe.tres"
	]
	for path in robe_paths:
		if ResourceLoader.exists(path):
			all_robes.append(ResourceLoader.load(path))

	var hat_paths = [
		"res://resources/hats/multi_tophat.tres",
		"res://resources/hats/power_crown.tres",
		"res://resources/hats/regen_beanie.tres",
		"res://resources/hats/speed_cap.tres",
		"res://resources/hats/mystic_turban.tres",
		"res://resources/hats/party_hat.tres"
	]
	for path in hat_paths:
		if ResourceLoader.exists(path):
			all_hats.append(ResourceLoader.load(path))

func show_popup():
	get_tree().paused = true
	visible = true
	reroll_button.disabled = false
	generate_choices()
	animate_cards_in()

func generate_choices():
	# Clear existing cards
	for child in card_container.get_children():
		child.queue_free()

	var player = get_tree().get_first_node_in_group("player")
	var choices = []

	# Option A & B: Upgrades (if possible)
	choices.append(get_upgrade_choice(player, choices))
	choices.append(get_upgrade_choice(player, choices))

	# Option C: New Item
	choices.append(get_new_item_choice(choices))

	for choice_data in choices:
		var card = choice_card_scene.instantiate()
		card_container.add_child(card)
		card.setup(choice_data)
		card.selected.connect(_on_card_selected)

func get_upgrade_choice(player, current_choices) -> Dictionary:
	var stats_list = ["damage", "speed", "fire_rate", "health"]
	var stat = stats_list.pick_random()

	# Try to avoid duplicate stats in the same popup
	var attempts = 0
	while attempts < 10:
		var duplicate = false
		for c in current_choices:
			if c.get("type") == "stat_upgrade" and c.get("stat") == stat:
				duplicate = true
				break
		if not duplicate:
			break
		stat = stats_list.pick_random()
		attempts += 1

	var rarities = ["common", "common", "common", "rare", "rare", "epic"]
	# Rarity Boost: 10% more rare/epic per level
	var meta = SaveManager.user_data.purchased_upgrades
	var rarity_boost = meta.get("rarity_boost", 0)
	for i in range(rarity_boost):
		rarities.append(["rare", "epic"].pick_random())

	var rarity = rarities.pick_random()
	var multiplier = 1.1
	if rarity == "rare": multiplier = 1.25
	if rarity == "epic": multiplier = 1.5

	var title = ""
	var desc = ""

	match stat:
		"damage":
			title = "Power Candy"
			desc = "Extra sugar for your projectiles! Damage +" + str(int((multiplier-1)*100)) + "%!"
		"speed":
			title = "Sugar Rush"
			desc = "Run like a candy cane! Speed +" + str(int((multiplier-1)*100)) + "%!"
		"fire_rate":
			title = "Rapid Refill"
			desc = "Don't stop the sweets! Fire Rate +" + str(int((multiplier-1)*100)) + "%!"
		"health":
			title = "Heart Truffle"
			desc = "A sweet treat for your heart! Max HP +10!"

	return {
		"type": "stat_upgrade",
		"stat": stat,
		"multiplier": multiplier,
		"title": title,
		"description": desc,
		"rarity": rarity,
		"texture": load("res://assets/sprites/candy_cane.png")
	}

func get_new_item_choice(current_choices) -> Dictionary:
	# Robust identification: remove .tres and common suffixes to match shop IDs
	var unlocked_robes = all_robes.filter(func(r):
		var id = r.resource_path.get_file().replace(".tres", "").replace("_robe", "")
		return SaveManager.user_data.unlocked_robes.has(id)
	)
	var unlocked_hats = all_hats.filter(func(h):
		var filename = h.resource_path.get_file().replace(".tres", "")
		return SaveManager.user_data.unlocked_hats.has(filename)
	)

	# If no robes or hats unlocked, just give stats (direct call, no recursion)
	if unlocked_robes.size() == 0 and unlocked_hats.size() == 0:
		var stat = ["damage", "speed", "fire_rate", "health"].pick_random()
		return {
			"type": "stat_upgrade",
			"stat": stat,
			"multiplier": 1.1,
			"title": stat.capitalize() + " Boost",
			"description": "Increases " + stat + " by 10%!",
			"rarity": "common",
			"texture": load("res://assets/sprites/candy_cane.png")
		}

	var is_robe = randf() > 0.5
	if unlocked_robes.size() == 0: is_robe = false
	if unlocked_hats.size() == 0: is_robe = true

	var attempts = 0

	if is_robe:
		var robe = unlocked_robes.pick_random()
		# Try to avoid duplicate robes in choices
		while attempts < 10:
			var duplicate = false
			for c in current_choices:
				if c.get("type") == "robe" and c.get("data") == robe:
					duplicate = true
					break
			if not duplicate: break
			robe = unlocked_robes.pick_random()
			attempts += 1

		return {
			"type": "robe",
			"data": robe,
			"title": robe.robe_name,
			"description": "Fresh from the loom! Extra spicy flames & " + str(int(robe.health_bonus)) + " health!",
			"rarity": "common",
			"texture": robe.base_texture
		}
	else:
		var hat = unlocked_hats.pick_random()
		while attempts < 10:
			var duplicate = false
			for c in current_choices:
				if c.get("type") == "hat" and c.get("data") == hat:
					duplicate = true
					break
			if not duplicate: break
			hat = unlocked_hats.pick_random()
			attempts += 1

		return {
			"type": "hat",
			"data": hat,
			"title": hat.hat_name,
			"description": "Accessorize your magic! Extra candy vibes & stats!",
			"rarity": "common",
			"texture": hat.hat_texture
		}

func animate_cards_in():
	var cards = card_container.get_children()
	for i in range(cards.size()):
		var card = cards[i]
		card.modulate.a = 0
		card.position.y += 100
		var tween = create_tween().set_parallel(true)
		tween.tween_property(card, "modulate:a", 1.0, 0.5).set_delay(i * 0.1)
		tween.tween_property(card, "position:y", card.position.y - 100, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_delay(i * 0.1)

func _on_card_selected(data):
	# Disable all cards immediately to prevent multiple clicks
	for card in card_container.get_children():
		card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	reroll_button.disabled = true

	var player = get_tree().get_first_node_in_group("player")
	if player:
		match data["type"]:
			"robe":
				player.equip_robe(data["data"])
			"hat":
				player.equip_hat(data["data"])
			"stat_upgrade":
				apply_stat_upgrade(player, data)

	confetti.emitting = true
	if choice_sound.stream:
		choice_sound.play()

	# Delay closing to see confetti
	var timer = get_tree().create_timer(1.0)
	timer.timeout.connect(func():
		visible = false
		get_tree().paused = false
	)

func _on_reroll_pressed():
	if SaveManager.spend_candy(50):
		generate_choices()
		animate_cards_in()
		reroll_button.disabled = true
		if choice_sound.stream:
			choice_sound.play()

func apply_stat_upgrade(player, data):
	var stat = data["stat"]
	var multiplier = data.get("multiplier", 1.1)

	match stat:
		"damage":
			player.stats.damage_multiplier *= multiplier
		"speed":
			player.stats.speed_multiplier *= multiplier
		"fire_rate":
			player.stats.fire_rate_multiplier *= multiplier
		"health":
			var bonus = 10
			player.max_health += bonus
			player.health += bonus
			GameManager.player_health_changed.emit(player.health, player.max_health)
