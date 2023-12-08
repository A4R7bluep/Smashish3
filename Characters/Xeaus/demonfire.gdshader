shader_type canvas_item;

uniform sampler2D clip_texture;

void fragment() {
	vec4 color = texture(clip_texture, UV);
	
	COLOR = color;
}
