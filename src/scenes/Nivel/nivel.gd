
extends Node2D

@onready var pc: Control = $Pc
@onready var avatar: Node2D = $CanvasLayer2/Avatar
@onready var efecto_tunel: ColorRect = $CanvasLayer/ColorRect
@onready var camara: Camera2D = $Camera2D
@onready var control: Control = $CanvasLayer2/Control
@onready var timer_temp: Timer = $TimerNotificaciones if has_node("TimerNotificaciones") else null


func _ready() -> void:
	if not timer_temp:
		timer_temp = Timer.new()
		timer_temp.name = "TimerNotificaciones"
		add_child(timer_temp)
		print("--- [SISTEMA] TimerNotificaciones creado automáticamente ---")

	print("--- INICIANDO NIVEL EXITOSAMENTE ---")

	GameManager.registrar_nivel(
		pc,
		avatar,
		timer_temp,
		efecto_tunel,
		camara,
	)
