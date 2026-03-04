shader_type spatial;

uniform vec4 glow_color : source_color = vec4(0.4, 0.6, 1.0, 1.0);
uniform float sway_speed : hint_range(0.0, 10.0) = 1.0;
uniform float sway_amplitude : hint_range(0.0, 5.0) = 0.05;

void vertex() {
	VERTEX.x += sin(TIME * sway_speed + VERTEX.y * 2.0) * sway_amplitude;
}

void fragment() {
	ALBEDO = glow_color.rgb;
	EMISSION = glow_color.rgb * 0.3;
	ALPHA = 0.9;
}
