shader_type canvas_item;

uniform vec4 crackle_color : source_color = vec4(1.0, 1.0, 0.4, 1.0);
uniform float crackle_speed : hint_range(0.0, 30.0) = 15.0;
uniform float sway_speed : hint_range(0.0, 10.0) = 2.5;
uniform float sway_amplitude : hint_range(0.0, 5.0) = 2.5;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_width : hint_range(0.0, 10.0) = 1.0;

float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453123);
}

void vertex() {
	VERTEX.x += sin(TIME * sway_speed + UV.y * 6.0) * sway_amplitude;
}

void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * outline_width;
	float a = texture(TEXTURE, UV + vec2(0.0, -size.y)).a;
	a += texture(TEXTURE, UV + vec2(0.0, size.y)).a;
	a += texture(TEXTURE, UV + vec2(-size.x, 0.0)).a;
	a += texture(TEXTURE, UV + vec2(size.x, 0.0)).a;
	a = min(a, 1.0);

	vec4 tex = texture(TEXTURE, UV);
	float crackle = step(0.9, random(UV + floor(TIME * crackle_speed))) * 0.5 + 0.5;

	float rim = 1.0 - clamp(dot(NORMAL, vec3(0.0, 0.0, 1.0)), 0.0, 1.0);
	rim = pow(rim, 3.0);

	vec4 main_color = tex * crackle_color * crackle;
	main_color.rgb += crackle_color.rgb * rim * 0.5;

	COLOR = mix(outline_color, main_color, tex.a);
	COLOR.a = a;
}
