extends Resource
class_name HatData

@export var hat_name: String = "Basic Hat"
@export var description: String = ""

@export_group("Visuals")
@export var hat_texture: Texture2D
@export var detail_texture: Texture2D
@export var base_color: Color = Color.WHITE
@export var bob_speed: float = 2.0
@export var bob_amplitude: float = 2.0
@export var shader_material: ShaderMaterial

@export_group("Stats")
@export var speed_bonus: float = 0.0
@export var damage_multiplier: float = 0.0
@export var regen_bonus: float = 0.0
@export var multi_shot_bonus: int = 0
