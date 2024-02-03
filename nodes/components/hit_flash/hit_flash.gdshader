shader_type canvas_item;

uniform float lerp_percentage: hint_range(0.0, 1.0);

void fragment() {
	vec4 pixel_color = texture(TEXTURE, UV);
	vec4 final_color = mix(
		pixel_color,
		vec4(1.0, 1.0, 1.0, pixel_color.a),
		lerp_percentage);

	COLOR = final_color;
}
