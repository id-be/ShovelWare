shader_type canvas_item;

uniform float amount = 40.0;

void vertex() {

	// Called for every vertex the material is visible on.
}

//void fragment() {
	//vec2 uv = UV*0.5;
	//float a = fract(sin(dot(UV, vec2(12.9898, 78.233)*TIME) * 438.5453) * 1.9);
	//
	//vec4 col = texture(TEXTURE, UV);
	//col.a *= pow(a, amount);
	//COLOR.a = col.a;
	//// Called for every pixel the material is visible on.
//}

void fragment() {
	vec2 uv = UV*0.5;
	float a = fract(sin(dot(UV, vec2(12.9898, 78.233)*TIME) * 438.5453) * 1.9);
////	float a = fract(sin(dot(UV, vec2(12.9898, 78.233)*TIME)) * 1.9);
////	float a = fract(sin(dot(UV, vec2(12.9898, 78.233)*TIME)) * 1.9);
	//float a = fract(UV.x*TIME);//scanline effect
	
	vec4 col = texture(TEXTURE, UV);
	col.a *= pow(a, amount);
	COLOR.a = col.a;
	COLOR = COLOR*10.0;
	// Called for every pixel the material is visible on.
}