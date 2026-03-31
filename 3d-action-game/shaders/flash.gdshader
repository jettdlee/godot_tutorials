shader_type spatial;

uniform float alpha: hint_range(0.0, 1.0) = 0.0;
uniform vec3 color: source_color = vec3(1.0);

void fragment() {
	ALBEDO = color;
	ALPHA = alpha;
}
