shader_type canvas_item;

uniform float star_density : hint_range(0.0, 1.0) = 0.982;
uniform float twinkle_speed = 2.0;
uniform float speed = 0.3;

float hash(vec2 p) {
    p = fract(p * vec2(234.34, 435.345));
    p += dot(p, p + 34.23);
    return fract(p.x * p.y);
}

void fragment() {
    vec2 uv = UV;
    uv.y -= TIME * speed * 0.15;

    vec2 pixel = floor(uv * vec2(256.0, 224.0));

    float rnd  = hash(pixel);
    float rnd2 = hash(pixel + 13.57);
    float rnd3 = hash(pixel + 91.13);

    float exists = step(star_density, rnd);

    float twinkle = sin(TIME * twinkle_speed * (0.3 + rnd * 1.5) + rnd3 * 6.28) * 0.5 + 0.5;
    float fade = step(0.25, twinkle) * twinkle;

    float brightness = exists * fade;

    vec3 col;
    if (rnd2 < 0.7) {
        col = vec3(1.0, 1.0, 1.0);
    } else if (rnd2 < 0.85) {
        col = vec3(0.6, 0.7, 1.0);
    } else {
        col = vec3(1.0, 0.5, 0.4);
    }

    COLOR = vec4(col * brightness * 0.45, 1.0);
}