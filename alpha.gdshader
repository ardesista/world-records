shader_type canvas_item;
render_mode blend_mix;

void fragment() {
    float f = smoothstep(.57, .67, UV.y >= .5 ? UV.y : 1.0 - UV.y);
    float c = clamp(texture(TEXTURE, UV).r - f, 0.0, 1.0);
    COLOR = vec4(vec3(c), f);
}
