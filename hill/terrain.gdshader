shader_type spatial;

uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D diffuse_texture : source_color;
uniform sampler2D mask_texture;
uniform sampler2D ambient_occlusion_roughness_metallic_texture;
uniform sampler2D normal_texture;
uniform vec2 near_scale = vec2(37.0);
uniform vec2 far_scale = vec2(5.0);
uniform float blend_distance = 3.0;

void fragment() {
	// Setup
	vec3 near_diffuse = texture(diffuse_texture, UV * near_scale).rgb;
	vec3 far_diffuse = texture(diffuse_texture, UV * far_scale).rgb;
	vec3 macro_variation_map = texture(mask_texture, UV * far_scale).rgb;

	// Z-buffer
	float depth = texture(depth_texture, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV, depth);

	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	float blend_rate = min(linear_depth / pow(2.0, blend_distance), 1.0);

	// Scale
	vec3 diffuse_near = texture(diffuse_texture, UV * near_scale).rgb;
	vec3 diffuse_far = texture(diffuse_texture, UV * far_scale).rgb;

	// Blending
	vec3 tmp_diffuse = mix(near_diffuse, far_diffuse, blend_rate); // Camera blend
	tmp_diffuse -= macro_variation_map * 0.1; // Macro variation

	ALBEDO = mix(diffuse_near, diffuse_far, blend_rate);
	// Debug
//	ALBEDO = diffuse_near;
//	ALBEDO = diffuse_far;
//	ALBEDO = vec3(blend_rate);

	// Setup
	vec3 arm_map = texture(ambient_occlusion_roughness_metallic_texture, UV * near_scale).rgb;
	vec3 normal_map = texture(normal_texture, UV * near_scale).rgb;
	NORMAL_MAP = normal_map;
	AO = arm_map.r;
	ROUGHNESS = arm_map.g;
	METALLIC = arm_map.b;
}
