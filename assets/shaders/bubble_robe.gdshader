shader_type canvas_item;

uniform float sway_speed : hint_range(0.0, 10.0) = 1.0;
uniform float sway_amplitude : hint_range(0.0, 5.0) = 1.5;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 1.0;

void vertex() {
	VERTEX.x += sin(TIME * sway_speed + UV.y * 4.0) * sway_amplitude;
}

void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * outline_width;
	float a = texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
	a += texture(TEXTURE, UV + vec2(0.0, size.y)).a;
	a += texture(TEXTURE, UV + vec2(-size.x, 0.0)).a;
	a += texture(TEXTURE, UV + vec2(size.x, 0.0)).a;
	a = min(a, 1.0);

	vec4 tex = texture(TEXTURE, UV);

	// Translucent bubble effect
	float bubble = sin(UV.x * 15.0 + TIME * 2.0) * sin(UV.y * 15.0 + TIME * 2.0) * 0.2 + 0.8;
	vec4 main_color = tex * vec4(0.7, 0.9, 1.0, 0.6) * bubble;

	COLOR = mix(outline_color, main_color, tex.a);
	COLOR.a = a;
}
