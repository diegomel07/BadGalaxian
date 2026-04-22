shader_type canvas_item;

uniform float scanline_strength : hint_range(0.0, 1.0) = 0.25;
uniform float blur_amount : hint_range(0.0, 3.0) = 0.8;
uniform float phosphor_glow : hint_range(0.0, 1.0) = 0.3;
uniform float curvature : hint_range(0.0, 0.5) = 0.04;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.35;

vec2 curve(vec2 uv) {
    uv = uv * 2.0 - 1.0;
    uv.x *= 1.0 + pow(uv.y, 2.0) * curvature;
    uv.y *= 1.0 + pow(uv.x, 2.0) * curvature;
    return uv * 0.5 + 0.5;
}

void fragment() {
    vec2 uv = curve(UV);

    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
    COLOR = vec4(0.0, 0.0, 0.0, 1.0);
} else {

    // Blur suave horizontal (simula el desenfoque del CRT)
    vec2 px = TEXTURE_PIXEL_SIZE * blur_amount;
    vec4 col  = texture(TEXTURE, uv);
    col += texture(TEXTURE, uv + vec2(px.x, 0.0));
    col += texture(TEXTURE, uv - vec2(px.x, 0.0));
    col /= 3.0;

    // Scanlines alineadas a píxeles
    float line = mod(floor(uv.y / TEXTURE_PIXEL_SIZE.y), 2.0);
    col.rgb *= 1.0 - scanline_strength * line;

    // Phosphor glow — los píxeles brillantes "sangran" a los vecinos
    vec4 glow = texture(TEXTURE, uv + vec2(px.x * 2.0, 0.0));
    glow += texture(TEXTURE, uv - vec2(px.x * 2.0, 0.0));
    glow += texture(TEXTURE, uv + vec2(0.0, px.y * 2.0));
    glow += texture(TEXTURE, uv - vec2(0.0, px.y * 2.0));
    glow /= 4.0;
    col.rgb += glow.rgb * phosphor_glow;

    // Viñeta
    vec2 vig = uv * (1.0 - uv.yx);
    col.rgb *= pow(vig.x * vig.y * 15.0, vignette_strength);

    COLOR = col;
}
}