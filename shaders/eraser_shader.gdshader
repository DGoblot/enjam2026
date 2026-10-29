shader_type canvas_item;

uniform sampler2D line_texture; // the texture to display
uniform ivec2 line_texture_size; // how large the texture will appear on screen
uniform vec2 camera_zoom;
uniform vec2 camera_pos;

void fragment() {
	ivec2 pixel_position = ivec2(SCREEN_UV / SCREEN_PIXEL_SIZE);
	
	vec2 local_pixel_position = vec2(float(pixel_position.x % line_texture_size.x), float(pixel_position.y % line_texture_size.y));
	vec2 texture_uv = local_pixel_position / vec2(line_texture_size);
	//TEXTURE_PIXEL_SIZE

	COLOR = texture(line_texture, texture_uv);
	vec2 ratio = vec2(line_texture_size) / TEXTURE_PIXEL_SIZE;
	COLOR = texture(line_texture, SCREEN_UV / camera_zoom + ratio * POINT_COORD);
}
