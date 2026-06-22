shader_type canvas_item;

uniform float intensity : hint_range(0.0, 1.0) = 0.3;
uniform float radius : hint_range(0.1, 2.0) = 0.75;
uniform float softness : hint_range(0.01, 1.0) = 0.45;

void fragment()
{
	vec2 uv = UV;

	vec2 center = vec2(0.5, 0.5);

	float distance_from_center =
		distance(uv, center);

	float vignette =
		smoothstep(
			radius,
			radius - softness,
			distance_from_center
		);

	float alpha =
		(1.0 - vignette) * intensity;

	COLOR = vec4(0.0, 0.0, 0.0, alpha);
}