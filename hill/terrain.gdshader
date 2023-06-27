shader_type spatial;

uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D diffuse_texture : source_color;
uniform sampler2D mask_texture;
uniform sampler2D ambient_occlusion_roughness_metallic_texture;
uniform sampler2D normal_texture;
/*
The forest_leaves_04 texture size is shot in 2m. and the mesh is 757m big
So 757m/2m(378) near scale is recommend
Use prime number on scale_near. (Not scale_far because scale_near is always bigger than scale_far)
So it never overlap exactly with scale_near at some point
So the closest prime number to 378 is 379
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
uniform vec2 scale_near = vec2(37.0);
uniform vec2 scale_far = vec2(5.0); // Recommend divided by 8 of scale_near
uniform vec2 scale_farther = vec2(4.0); // Recommend 4
uniform float diffuse_stacking_near = 0.5;
uniform float diffuse_stacking_farther = 0.9;
uniform vec2 diffuse_shift_scale_near = vec2(1.0); // You are supposed to decrease the scale
uniform vec2 diffuse_shift_scale_far = vec2(1.0);
uniform float minimum_blend_distance = 5.0;
uniform float blend_distance_far = 3.5;
uniform float blend_distance_farther = 8.0;
uniform float macro_variation_strength = 0.03;
uniform float desaturation_strength = 0.0;

void fragment() {
	const float CLAMP_MIN = 0.0;
	const float CLAMP_MAX = 1.0;

	// Setup texture
	vec3 diffuse_near = texture(diffuse_texture, UV * scale_near).rgb;
	vec3 diffuse_far = texture(diffuse_texture, UV * scale_far).rgb;
	vec3 diffuse_farther = texture(diffuse_texture, UV * scale_farther).rgb;
	vec3 macro_variation_map = texture(mask_texture, UV * 2.0).rgb;

	// Diffuse texture stacking
	vec3 tmp_diffuse_near = texture(diffuse_texture, UV * scale_near * diffuse_shift_scale_near).rgb;
	diffuse_near = mix(diffuse_near, tmp_diffuse_near, diffuse_stacking_near);

	vec3 tmp_diffuse_far = texture(diffuse_texture, UV * scale_far * diffuse_shift_scale_far).rgb;
	diffuse_far = mix(diffuse_far, tmp_diffuse_far, diffuse_stacking_near);

	vec3 tmp_diffuse_farther = texture(diffuse_texture, UV * scale_farther).rgb;
	diffuse_farther = mix(diffuse_farther, tmp_diffuse_farther, diffuse_stacking_farther);

	// Z-buffer
	float depth = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV, depth);

	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	float blend_rate_far = clamp((linear_depth - minimum_blend_distance) / pow(2.0, blend_distance_far), CLAMP_MIN, CLAMP_MAX);
	float blend_rate_farther = clamp((linear_depth - minimum_blend_distance) / pow(2.0, blend_distance_farther), CLAMP_MIN, CLAMP_MAX);

	// Blending
	vec3 tmp_diffuse = mix(diffuse_near, diffuse_far, blend_rate_far); // Camera blend
	vec3 diffuse_far_stack = diffuse_farther;
	tmp_diffuse = mix(tmp_diffuse, diffuse_far_stack, blend_rate_farther);
	// It doesn't clamp the white color clip for artistic choice
	tmp_diffuse = max(tmp_diffuse - macro_variation_map * macro_variation_strength, CLAMP_MIN);
	// Use it on bad texture for hiding identifiable landmark
	// But it's much better to desaturate it by hand. Use it as a last resort
	float dot_product = dot(vec3(1.0), tmp_diffuse) * (1.0 / 3.0);
	tmp_diffuse = mix(tmp_diffuse, vec3(dot_product), desaturation_strength);

	ALBEDO = tmp_diffuse;
	// Debug
//	ALBEDO = diffuse_near;
//	ALBEDO = diffuse_far;
//	ALBEDO = diffuse_farther;
//	ALBEDO = vec3(blend_rate_far, 0.0, blend_rate_farther); // Blue for easier to see

	// Setup texture
	vec3 arm_map = texture(ambient_occlusion_roughness_metallic_texture, UV * scale_near).rgb;
	vec3 arm_map_far = texture(ambient_occlusion_roughness_metallic_texture, UV * scale_far).rgb;
	arm_map = mix(arm_map, arm_map_far, blend_rate_far);
	vec3 normal_map = texture(normal_texture, UV * scale_near).rgb;
	vec3 normal_map_far = texture(normal_texture, UV * scale_far).rgb;
	normal_map = mix(normal_map, normal_map_far, blend_rate_far);

	NORMAL_MAP = normal_map;
	AO = arm_map.r;
	ROUGHNESS = arm_map.g;
	METALLIC = arm_map.b;
}
