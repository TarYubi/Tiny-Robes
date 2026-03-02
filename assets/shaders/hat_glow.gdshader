shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 0.7, 1.0);
uniform float pulse_speed : hint_range(0.0, 10.0) = 2.0;
uniform float glow_intensity : hint_range(0.0, 1.0) = 0.3;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float pulse = (sin(TIME * pulse_speed) * 0.5 + 0.5) * glow_intensity;
	COLOR = tex;
	COLOR.rgb += glow_color.rgb * pulse * tex.a;
}
