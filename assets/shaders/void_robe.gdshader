shader_type spatial;

uniform vec4 glow_color : source_color = vec4(0.1, 0.0, 0.2, 1.0);

void fragment() {
	ALBEDO = vec3(0.0);
	EMISSION = glow_color.rgb * (1.0 - UV.y);
}
