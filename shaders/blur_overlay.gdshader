shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform float blur_strength : hint_range(0.0, 1.0) = 0.0;

void fragment()
{
	vec2 uv = SCREEN_UV;

	float radius = blur_strength * 0.01;

	vec4 center =
		texture(screen_texture, uv);

	vec4 left =
		texture(
			screen_texture,
			uv + vec2(-radius, 0.0)
		);

	vec4 right =
		texture(
			screen_texture,
			uv + vec2(radius, 0.0)
		);

	vec4 up =
		texture(
			screen_texture,
			uv + vec2(0.0, -radius)
		);

	vec4 down =
		texture(
			screen_texture,
			uv + vec2(0.0, radius)
		);

	COLOR =
		(center + left + right + up + down)
		/ 5.0;
}