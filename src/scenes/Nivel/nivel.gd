extends Node2D

@onready var avatar: Node2D = $Avatar
@onready var pc: Control = $Pc

# Si agregaste un Timer a tu nivel (por ejemplo, dentro del nivel o un nodo hijo):
# @onready var timer_notificaciones: Timer = $TimerNotificaciones

func _ready() -> void:
	# Si no tenías un nodo Timer en la escena, creamos uno dinámico de apoyo:
	var timer_temp = Timer.new()
	add_child(timer_temp)
	
	# Registramos las referencias en el Autoload GameManager
	GameManager.registrar_nivel(pc, avatar, timer_temp)
