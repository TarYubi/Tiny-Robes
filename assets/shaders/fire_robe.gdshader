shader_type spatial;

uniform vec4 glow_color : source_color = vec4(1.0, 0.4, 0.0, 1.0);
uniform float flicker_speed : hint_range(0.0, 20.0) = 5.0;
uniform float sway_speed : hint_range(0.0, 10.0) = 2.0;
uniform float sway_amplitude : hint_range(0.0, 5.0) = 0.1;

void vertex() {
	VERTEX.x += sin(TIME * sway_speed + VERTEX.y * 5.0) * sway_amplitude;
}

void fragment() {
	float flicker = (sin(TIME * flicker_speed) * 0.5 + 0.5) * 0.4 + 0.6;
	ALBEDO = glow_color.rgb * flicker;
	EMISSION = glow_color.rgb * flicker * 0.5;
}
