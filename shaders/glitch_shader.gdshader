shader_type canvas_item;

// =========================
// SCREEN TEXTURE (GODOT 4 FIX)
// =========================
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// =========================
// CONTROLS
// =========================
uniform float intensity = 0.0;
uniform float time_speed = 1.0;

uniform float scanline_strength = 0.3;
uniform float rgb_shift = 0.01;
uniform float distortion = 0.05;

void fragment() {

	vec2 uv = SCREEN_UV;

	// =====================================================
	// DISTORTION (GELOMBANG HORROR)
	// =====================================================
	float wave = sin(uv.y * 20.0 + TIME * 8.0 * time_speed);
	uv.x += wave * distortion * intensity;

	// =====================================================
	// RGB SHIFT (GLITCH WARNA)
	// =====================================================
	float shift = rgb_shift * intensity;

	float r = texture(SCREEN_TEXTURE, uv + vec2(shift, 0.0)).r;
	float g = texture(SCREEN_TEXTURE, uv).g;
	float b = texture(SCREEN_TEXTURE, uv - vec2(shift, 0.0)).b;

	vec3 color = vec3(r, g, b);

	// =====================================================
	// SCANLINE (TV HORROR)
	// =====================================================
	float scan = sin(uv.y * 800.0);
	color -= scan * scanline_strength * intensity;

	// =====================================================
	// OUTPUT
	// =====================================================
	COLOR = vec4(color, 1.0);
}