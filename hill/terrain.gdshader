shader_type spatial;

uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D diffuse_texture : source_color;
uniform sampler2D mask_texture;
uniform sampler2D ambient_occlusion_roughness_metallic_texture;
uniform sampler2D normal_texture;
// The forest_leaves_04 texture size is shot in 2m. and the mesh is 757m big
// So 757m/2m(378) near scale is recommend
uniform vec2 near_scale = vec2(37.0);
/* Use prime number on far_scale. So it never overlap exactly with near_scale at some point
2, 3, 5, 7,
11, 13, 17, 19,
23, 29,
31, 37,
41, 43, 47,
53, 59,
61, 67,
71, 73, 79,
83, 89,
97
*/
uniform vec2 far_scale = vec2(5.0);
uniform float minimum_blend_distance = 1.5;
uniform float blend_distance = 3.0;
uniform float macro_variation_strength = 0.1;
uniform float desaturation_strength = 0.0;

void fragment() {
	// Setup texture
	vec3 diffuse_near = texture(diffuse_texture, UV * near_scale).rgb;
	vec3 diffuse_far = texture(diffuse_texture, UV * far_scale).rgb;
	vec3 macro_variation_map = texture(mask_texture, UV * mix(near_scale, far_scale, 0.5)).rgb;

	// Z-buffer
	float depth = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV, depth);

	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	float blend_rate = clamp((linear_depth - minimum_blend_distance) / pow(2.0, blend_distance), 0.0, 1.0);

	// Blending
	vec3 tmp_diffuse = mix(diffuse_near, diffuse_far, blend_rate); // Camera blend
	// It doesn't clamp the white color clip for artistic choice
	tmp_diffuse = max(tmp_diffuse - macro_variation_map * macro_variation_strength, 0.0);
	// Use it on bad texture for hiding identifiable landmark
	// But it's much better to desaturate it by hand
	float dot_product = dot(vec3(1.0), tmp_diffuse) * (1.0 / 3.0);
	tmp_diffuse = mix(tmp_diffuse, vec3(dot_product), desaturation_strength);

	ALBEDO = tmp_diffuse;
	// Debug
//	ALBEDO = diffuse_near;
//	ALBEDO = diffuse_far;
//	ALBEDO = vec3(blend_rate);

	// Setup texture
	vec3 arm_map = texture(ambient_occlusion_roughness_metallic_texture, UV * near_scale).rgb;
	vec3 normal_map = texture(normal_texture, UV * near_scale).rgb;
	NORMAL_MAP = normal_map;
	AO = arm_map.r;
	ROUGHNESS = arm_map.g;
	METALLIC = arm_map.b;
}
