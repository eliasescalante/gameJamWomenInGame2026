extends Node2D

@onready var pc: Control = $Pc
@onready var avatar: Node2D = $CanvasLayer2/Avatar
@onready var efecto_tunel: ColorRect = $CanvasLayer/ColorRect
@onready var camara: Camera2D = $Camera2D
@onready var control: Control = $CanvasLayer2/Control
@onready var timer_temp: Timer = $TimerNotificaciones if has_node("TimerNotificaciones") else null

# --- SISTEMA DE ÍCONOS VISUALES ---
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
	timer_gestion_iconos.wait_time = 1.5
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
		null,
		self
	)

# --- MÉTODOS PÚBLICOS LLAMADOS POR EL GAMEMANAGER ---

func activar_peligro_iconos() -> void:
	if esta_en_peligro: 
		return
	esta_en_peligro = true
	timer_gestion_iconos.wait_time = 0.8 # Ritmo más ágil para spawnear íconos en 10 preguntas
	print("--- [ICONOS] Estado: PELIGRO (Acumulando íconos) ---")

func activar_calma_iconos() -> void:
	if not esta_en_peligro: 
		return
	esta_en_peligro = false
	timer_gestion_iconos.wait_time = 1.2 # Limpieza fluida en estado seguro
	print("--- [ICONOS] Estado: CALMA (Limpiando 1 a 1) ---")

# --- LÓGICA INTERNA DE SPAWN Y LIMPIEZA ---

func _procesar_ciclo_iconos() -> void:
	if esta_en_peligro:
		if lista_iconos_activos.size() < max_iconos_acumulados:
			_spawnear_icono()
	else:
		if not lista_iconos_activos.is_empty():
			_limpiar_icono_mas_viejo()

func _spawnear_icono() -> void:
	var nuevo_icono = escena_icono.instantiate()
	var screen_size = get_viewport().get_visible_rect().size
	
	var pos_x = randf_range(50.0, screen_size.x - 50.0)
	var pos_y = randf_range(50.0, screen_size.y - 50.0)
	nuevo_icono.position = Vector2(pos_x, pos_y)
	
	add_child(nuevo_icono)
	lista_iconos_activos.append(nuevo_icono)

func _limpiar_icono_mas_viejo() -> void:
	var icono_a_borrar = lista_iconos_activos.pop_front()
	if is_instance_valid(icono_a_borrar):
		var tween = create_tween()
		tween.tween_property(icono_a_borrar, "modulate:a", 0.0, 0.4)
		tween.tween_callback(icono_a_borrar.queue_free)
