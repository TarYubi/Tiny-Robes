shader_type spatial;

uniform vec4 glow_color : source_color = vec4(0.6, 0.4, 1.0, 1.0);
uniform float flicker_speed : hint_range(0.0, 20.0) = 2.0;

void fragment() {
	float flicker = (sin(TIME * flicker_speed) * 0.5 + 0.5) * 0.2 + 0.8;
	ALBEDO = glow_color.rgb * flicker;
	EMISSION = glow_color.rgb * flicker * 0.4;
}
