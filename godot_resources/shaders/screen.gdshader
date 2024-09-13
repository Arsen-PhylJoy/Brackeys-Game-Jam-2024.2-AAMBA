shader_type spatial;

uniform sampler2D visual;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	vec4 alb = texture(visual, uv);
	ALBEDO = vec3(alb.x,alb.y,alb.z);
}
