extends Area2D

@export var robe_data: RobeData

func _ready():
	if robe_data:
<<<<<<< HEAD
		$Sprite2D.texture = robe_data.sprite_texture
=======
		# Use base texture for the pickup icon
		if robe_data.base_texture:
			$Sprite2D.texture = robe_data.base_texture
		# If the sprite sheet is horizontal (which mine is), we might want to show only the first frame
		if $Sprite2D.texture and $Sprite2D.texture.get_width() > 64:
			$Sprite2D.hframes = 8
			$Sprite2D.frame = 0
>>>>>>> origin/luna-premium-robes-layers-shaders-10532435458121204687
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.equip_robe(robe_data)
		queue_free()
