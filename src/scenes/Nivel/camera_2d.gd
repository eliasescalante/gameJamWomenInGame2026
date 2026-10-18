extends Camera2D

@export var zoom_base: Vector2 = Vector2(1.0, 1.0)

# Parámetros suavizados
@export var profundidad_pulsacion_max: float = 0.08  # Reducido: zoom máximo del 100% al 92%
@export var velocidad_pulsacion_base: float = 1.8     # Ritmo muy lento en la zona de advertencia
@export var velocidad_pulsacion_max: float = 3.5      # Ritmo pausado y pesado en estrés máximo

var intensidad_pulsacion: float = 0.0
var tiempo: float = 0.0

func _ready() -> void:
	zoom = zoom_base

func _process(delta: float) -> void:
	# Si estamos dentro del rango seguro (35 a 65), la cámara se queda fija en zoom normal
	if intensidad_pulsacion < 0.01:
		zoom = zoom_base
		tiempo = 0.0
		return
		
	# Mapeamos la intensidad a una velocidad y profundidad mucho más lentas y orgánicas
	var profundidad_actual = lerp(0.02, profundidad_pulsacion_max, intensidad_pulsacion)
	var velocidad_actual = lerp(velocidad_pulsacion_base, velocidad_pulsacion_max, intensidad_pulsacion)
	
	tiempo += delta * velocidad_actual
	
	# Onda sinusoidal suave para contracción y expansión sutil
	var factor_onda = (sin(tiempo) + 1.0) * 0.5
	
	# Aplicamos el zoom sutil
	var zoom_x = zoom_base.x - (factor_onda * profundidad_actual)
	var zoom_y = zoom_base.y - (factor_onda * profundidad_actual)
	zoom = Vector2(zoom_x, zoom_y)

func establecer_intensidad_pulsacion(nivel: float) -> void:
	intensidad_pulsacion = nivel
