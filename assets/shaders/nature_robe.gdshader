shader_type spatial;

uniform vec4 glow_color : source_color = vec4(0.2, 0.8, 0.2, 1.0);
uniform float sway_speed : hint_range(0.0, 10.0) = 0.5;

void vertex() {
	VERTEX.y += sin(TIME * sway_speed) * 0.02;
}

void fragment() {
	ALBEDO = glow_color.rgb;
	EMISSION = glow_color.rgb * 0.2;
}
