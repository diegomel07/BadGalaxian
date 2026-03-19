shader_type canvas_item;

uniform float speed = .5;
uniform float intensity = 1.5;
uniform float density = 50.0;

// Hash simple para pseudo-aleatoriedad
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void fragment() {
	UV.y -= TIME * speed; 
    vec4 tex = texture(TEXTURE, UV);

    // Detectar estrellas (blanco)
    float star = tex.r;

    if (star > 0.8) {
        // Coordenadas discretizadas para separar estrellas
        vec2 id = floor(UV * density);

        // Fase aleatoria por estrella
        float rnd = hash(id);

        // Variación suave (no ruido brusco)
        float twinkle = sin(TIME * speed + rnd * 6.2831) * 0.5 + 0.5;

        // Intensidad final
        float glow = mix(0.5, 1.0, twinkle) * intensity;

        COLOR = vec4(vec3(glow), 1.0);
    } else {
        COLOR = tex;
    }
}