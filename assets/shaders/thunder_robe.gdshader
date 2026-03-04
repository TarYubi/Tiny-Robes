shader_type spatial;

uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 0.2, 1.0);
uniform float flicker_speed : hint_range(0.0, 50.0) = 20.0;

void fragment() {
	float flicker = step(0.8, sin(TIME * flicker_speed));
	ALBEDO = mix(glow_color.rgb * 0.5, glow_color.rgb, flicker);
	EMISSION = glow_color.rgb * flicker;
}
