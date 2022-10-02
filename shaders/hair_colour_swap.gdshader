shader_type canvas_item;

uniform vec4 band_color : source_color;
uniform vec4 hair_color : source_color;
uniform vec4 hair_color_shade : source_color;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
	
	if (color.a < 0.1) {
	} else {
	    if (color.r  > 0.1 && color.g > 0.4) {
			color = band_color;
	    } else {
			if (color.r < 0.5) {
				color = hair_color_shade;
			} else {
				color = hair_color;
			}
		}
	}
    COLOR = color;
}