shader_type canvas_item;

uniform float scan_line_strength : hint_range(0.0, 1.0) = 0.3;
uniform float curvature : hint_range(0.0, 0.5) = 0.08;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.4;
uniform float brightness = 1.1;

vec2 curve(vec2 uv) {
    uv = uv * 2.0 - 1.0;
    uv.x *= 1.0 + pow(uv.y, 2.0) * curvature;
    uv.y *= 1.0 + pow(uv.x, 2.0) * curvature;
    return uv * 0.5 + 0.5;
}

void fragment() {
    vec2 uv = curve(UV);

    // 1.0 si está dentro de pantalla, 0.0 si está fuera
    float inside = step(0.0, uv.x) * step(uv.x, 1.0)
                 * step(0.0, uv.y) * step(uv.y, 1.0);

    vec4 col = texture(TEXTURE, clamp(uv, 0.0, 1.0));

    // Scanlines
    float scan = sin(uv.y * SCREEN_PIXEL_SIZE.y * 3.14159 * 800.0) * 0.5 + 0.5;
    scan = pow(scan, 0.5);
    col.rgb *= mix(1.0 - scan_line_strength, 1.0, scan);

    // Viñeta
    vec2 vig_uv = uv * (1.0 - uv.yx);
    float vignette = pow(vig_uv.x * vig_uv.y * 15.0, vignette_strength);
    col.rgb *= vignette;

    // Brillo
    col.rgb *= brightness;

    // Fuera de la curva queda negro
    COLOR = mix(vec4(0.0, 0.0, 0.0, 1.0), col, inside);
}