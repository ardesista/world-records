shader_type canvas_item;
render_mode blend_mix;

void fragment() {
    float f = smoothstep(.62, .7, UV.y >= .5 ? UV.y : 1.0 - UV.y);
    COLOR = vec4(vec3(.0), f / clamp(texture(TEXTURE, UV).r, 0.01, 1.0));
}
