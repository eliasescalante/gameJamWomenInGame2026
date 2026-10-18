extends Node2D

@onready var avatar: Node2D = $CanvasLayer2/Avatar
@onready var pc: Control = $Pc
@onready var efecto_tunel: ColorRect = $CanvasLayer/ColorRect
@onready var camara: Camera2D = $Camera2D # <--- Referencia al nodo Camera2D

func _ready() -> void:
	var timer_temp = Timer.new()
	add_child(timer_temp)
	
	# Registramos las referencias incluyendo la cámara para el shake
	GameManager.registrar_nivel(pc, avatar, timer_temp, efecto_tunel, camara)
