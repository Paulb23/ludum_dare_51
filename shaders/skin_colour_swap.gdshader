shader_type canvas_item;

uniform vec4 skin_color : source_color;
uniform vec4 skin_color_shade : source_color;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
	
	if (color.a < 0.1) {
	} else {
	    if (color.r  > 0.94 && color.g > 0.8) {
			color = skin_color;
	    } else if (color.r  > 0.94) {
			color = skin_color_shade;
		}
	}
    COLOR = color;
}