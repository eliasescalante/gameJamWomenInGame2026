shader_type canvas_item;

uniform float intensidad : hint_range(0.0, 1.0) = 0.0;
uniform float suavizado : hint_range(0.0, 1.0) = 0.25;

void fragment() {
    vec2 centro = UV - vec2(0.5);
    float dist = length(centro);
    
    // Limitamos el radio mínimo a 0.28 para que NUNCA se vuelva negra toda la pantalla
    float radio = mix(0.95, 0.28, intensidad);
    
    float alfa = smoothstep(radio - suavizado, radio, dist);
    
    // Limitamos la opacidad máxima a 0.85 para mantener visibilidad de la UI en el centro
    COLOR = vec4(0.0, 0.0, 0.0, clamp(alfa, 0.0, 0.85));
}