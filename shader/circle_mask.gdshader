shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 1.0;
uniform vec2 center = vec2(0.5, 0.5);
uniform vec4 color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	float dist = distance(center, UV);
	float mask = step(progress, dist);
	COLOR = vec4(color.rgb, mask * color.a);
}
