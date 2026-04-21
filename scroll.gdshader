shader_type canvas_item;

uniform float star_density : hint_range(0.0, 1.0) = 0.99;
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

    // cell_id es la "identidad" estable de la estrella (no cambia con el tiempo)
    vec2 scaled = uv * vec2(256.0, 224.0);
    vec2 cell_id = floor(scaled);

    // rnd se calcula solo con cell_id, no con TIME
    float rnd  = hash(cell_id);
    float rnd2 = hash(cell_id + 13.57);
    float rnd3 = hash(cell_id + 91.13);

    float exists = step(star_density, rnd);

    float twinkle = sin(TIME * twinkle_speed * (0.3 + rnd * 1.5) + rnd3 * 6.28) * 0.5 + 0.5;
    float fade = step(0.25, twinkle) * twinkle;

    float brightness = exists * fade;

    vec3 col;
    if (rnd2 < 0.7) {
        col = vec3(1.0, 1.0, 1.0);
    } else if (rnd2 < 0.85) {
        col = vec3(1.0, 1.0, 1.0);
    } else {
        col = vec3(1.0, 1.0, 1.0);
    }

    COLOR = vec4(col * brightness * 0.45, 1.0);
}