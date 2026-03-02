extends Control

@onready var text_label = $Content/TextLabel
@onready var wizard_chibi = $Content/WizardChibi
@onready var type_sound = $TypeSound
@onready var music = $Music

var story_beats = [
	{
		"text": "[center][wave]In the heart of the Candy Kingdom...[/wave]\nAn apprentice wizard was practicing his most delicious spells.[/center]",
		"image": "res://assets/sprites/player/chibi_base.png"
	},
	{
		"text": "[center]But a [color=purple]Mischievous Candy Sorcerer[/color] was jealous of his talent!\nWith a sour zap, he cast a terrible curse![/center]",
		"image": ""
	},
	{
		"text": "[center]The wizard was stripped of his [color=gold]Fancy Robes[/color] and [color=gold]Magic Hats[/color]...\n...leaving him in nothing but silly heart-patterned underwear![/center]",
		"image": "res://assets/sprites/player/chibi_walk.png"
	},
	{
		"text": "[center]The curse turned all the kingdom's adorable animals into\n[shake rate=20 level=10][color=red]Aggressive Sugar Monsters![/color][/shake][/center]",
		"image": "res://assets/sprites/bunny.png"
	},
	{
		"text": "[center]Now, the wizard must fight back, reclaim his wardrobe,\nand break the sour spell![/center]",
		"image": "res://assets/sprites/player/chibi_base.png"
	},
	{
		"text": "[center][rainbow rate=1.0 sat=0.8 val=0.8]Dress to survive... and look fabulous doing it![/rainbow][/center]",
		"image": ""
	}
]

var current_beat = 0
var typing = false

func _ready():
	if SaveManager.user_data.seen_intro:
		start_game()
		return

	wizard_chibi.modulate.a = 0
	text_label.modulate.a = 0
	show_beat(0)

func show_beat(index):
	if index >= story_beats.size():
		finish_intro()
		return

	current_beat = index
	var beat = story_beats[index]

	# Transition out old content if not first beat
	if index > 0:
		var fade_out = create_tween().set_parallel(true)
		fade_out.tween_property(wizard_chibi, "modulate:a", 0, 0.5)
		fade_out.tween_property(text_label, "modulate:a", 0, 0.5)
		await fade_out.finished

	# Setup new content
	if beat["image"] != "" and ResourceLoader.exists(beat["image"]):
		wizard_chibi.texture = load(beat["image"])

	text_label.text = beat["text"]
	text_label.visible_ratio = 0

	# Transition in
	var fade_in = create_tween().set_parallel(true)
	fade_in.tween_property(wizard_chibi, "modulate:a", 1, 0.5)
	fade_in.tween_property(text_label, "modulate:a", 1, 0.5)

	# Small bounce/bob for chibi
	var bob = create_tween().set_loops()
	bob.tween_property(wizard_chibi, "position:y", wizard_chibi.position.y - 10, 1.0).set_trans(Tween.TRANS_SINE)
	bob.tween_property(wizard_chibi, "position:y", wizard_chibi.position.y, 1.0).set_trans(Tween.TRANS_SINE)

	await fade_in.finished

	# Typewriter effect
	typing = true
	var type_tween = create_tween()
	type_tween.tween_property(text_label, "visible_ratio", 1.0, 3.0)

	# Sound while typing (simple looping placeholder)
	if type_sound.stream:
		type_sound.play()

	await type_tween.finished
	typing = false
	type_sound.stop()

	# Wait for a bit before next beat, or user click
	await get_tree().create_timer(4.0).timeout
	if current_beat == index: # Ensure we haven't skipped ahead
		show_beat(index + 1)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		advance()
	elif event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		advance()

func advance():
	if typing:
		# Skip typing
		text_label.visible_ratio = 1.0
		return

	show_beat(current_beat + 1)

func _on_skip_pressed():
	finish_intro()

func finish_intro():
	SaveManager.user_data.seen_intro = true
	SaveManager.save_game()
	start_game()

func start_game():
	get_tree().change_scene_to_file("res://scenes/UI/MainMenu.tscn")
