extends Node2D

@onready var pc: Control = $Pc
@onready var avatar: Node2D = $CanvasLayer2/Avatar
@onready var efecto_tunel: ColorRect = $CanvasLayer/ColorRect
@onready var camara: Camera2D = $Camera2D
@onready var control: Control = $CanvasLayer2/Control
@onready var timer_temp: Timer = $TimerNotificaciones if has_node("TimerNotificaciones") else null

# --- SISTEMA DE ÍCONOS VISUALES ---
# Ajusta esta ruta a donde tengas guardada la escena del ícono:
var escena_icono = preload("res://src/scenes/Entidades/IconosSpawner/IconosSpawner.tscn")

var timer_gestion_iconos: Timer = null
var lista_iconos_activos: Array = []
var max_iconos_acumulados: int = 40
var esta_en_peligro: bool = false

func _ready() -> void:
	if not timer_temp:
		timer_temp = Timer.new()
		timer_temp.name = "TimerNotificaciones"
		add_child(timer_temp)
		print("--- [SISTEMA] TimerNotificaciones creado automáticamente ---")

	# Inicializamos el temporizador de gestión de íconos
	timer_gestion_iconos = Timer.new()
	timer_gestion_iconos.wait_time = 2.5
	timer_gestion_iconos.autostart = true
	timer_gestion_iconos.timeout.connect(_procesar_ciclo_iconos)
	add_child(timer_gestion_iconos)

	print("--- INICIANDO NIVEL EXITOSAMENTE ---")

	GameManager.registrar_nivel(
		pc,
		avatar,
		timer_temp,
		efecto_tunel,
		camara,
		null, # Si no usas la escena independiente de pensamientos, pasamos null
		self  # Le pasamos esta instancia del Nivel al GameManager
	)

# --- MÉTODOS PÚBLICOS LLAMADOS POR EL GAMEMANAGER ---

func activar_peligro_iconos() -> void:
	if esta_en_peligro: 
		return
	esta_en_peligro = true
	timer_gestion_iconos.wait_time = 1.0 # Aparecen más rápido cuando hay peligro
	print("--- [ICONOS] Estado: PELIGRO (Acumulando íconos) ---")

func activar_calma_iconos() -> void:
	if not esta_en_peligro: 
		return
	esta_en_peligro = false
	timer_gestion_iconos.wait_time = 2.5 # Se eliminan más pausadamente en calma
	print("--- [ICONOS] Estado: CALMA (Limpiando 1 a 1) ---")

# --- LÓGICA INTERNA DE SPAWN Y LIMPIEZA ---

func _procesar_ciclo_iconos() -> void:
	if esta_en_peligro:
		# Si está desbalanceado y no supera el límite, crea un ícono nuevo
		if lista_iconos_activos.size() < max_iconos_acumulados:
			_spawnear_icono()
	else:
		# Si está en calma, elimina el ícono más antiguo de la pantalla
		if not lista_iconos_activos.is_empty():
			_limpiar_icono_mas_viejo()

func _spawnear_icono() -> void:
	var nuevo_icono = escena_icono.instantiate()
	var screen_size = get_viewport().get_visible_rect().size
	
	# Coordenadas aleatorias dentro de la pantalla (con margen de 50px)
	var pos_x = randf_range(50.0, screen_size.x - 50.0)
	var pos_y = randf_range(50.0, screen_size.y - 50.0)
	nuevo_icono.position = Vector2(pos_x, pos_y)
	
	add_child(nuevo_icono)
	lista_iconos_activos.append(nuevo_icono)

func _limpiar_icono_mas_viejo() -> void:
	var icono_a_borrar = lista_iconos_activos.pop_front()
	if is_instance_valid(icono_a_borrar):
		# Animación de desvanecimiento suave antes de eliminarlo
		var tween = create_tween()
		tween.tween_property(icono_a_borrar, "modulate:a", 0.0, 0.4)
		tween.tween_callback(icono_a_borrar.queue_free)
