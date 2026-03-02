shader_type canvas_item;

uniform float shine_progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 shine_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float shine_size : hint_range(0.01, 1.0) = 0.1;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float sheen = step(1.0 - shine_size, 1.0 - abs(UV.x - shine_progress * 1.5 + 0.25));
	COLOR = tex;
	COLOR.rgb += shine_color.rgb * sheen * tex.a * 0.5;
}
