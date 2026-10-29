shader_type canvas_item;

uniform float grain_scale : hint_range(0.1, 10.0) = 1.5;
uniform float grain_strength : hint_range(0.0, 1.0) = 0.6;
uniform float roughness : hint_range(0.0, 3.0) = 0.8;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;

varying vec2 local_pos;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    f = f * f * (3.0 - 2.0 * f);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void vertex() {
    local_pos = VERTEX;

    float n1 = noise(VERTEX * 0.35);
    float n2 = noise(VERTEX * 0.35 + vec2(19.2, 7.4));

    VERTEX += vec2(n1 - 0.5, n2 - 0.5) * roughness;
}

void fragment() {
    float coarse = noise(local_pos * grain_scale * 0.3);
    float fine = hash(floor(local_pos * grain_scale * 2.0));

    float grain = mix(coarse, fine, 0.6);

    float density = 1.0 - grain_strength * grain;

    COLOR.a *= density * opacity;
}
