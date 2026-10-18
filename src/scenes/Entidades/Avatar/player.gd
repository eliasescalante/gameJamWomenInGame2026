extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $PanelContainer/AnimatedSprite2D

func _ready() -> void:
	# Arranca en la animación "1" por defecto (balanceado)
	animated_sprite.play("1")

func _on_puntaje_cambiado(nuevo_puntaje: int) -> void:
	actualizar_animacion_por_puntaje(nuevo_puntaje)

func actualizar_animacion_por_puntaje(puntaje: int) -> void:
	# Calculamos qué tan lejos estamos del centro (50). 
	# abs() nos sirve para que no importe si el puntaje sube a 80 o baja a 20; 
	# la distancia al centro es la misma (30 de distancia).
	var distancia_del_centro: float = abs(puntaje - 50.0)
	
	# Evaluamos el nivel de desbalance por rangos de distancia:
	if distancia_del_centro <= 10.0:
		# Muy cerca del centro (entre 40 y 60): Totalmente balanceado
		animated_sprite.play("1")
	elif distancia_del_centro <= 25.0:
		# Desbalance leve (entre 25-39 o 61-75)
		animated_sprite.play("2")
	elif distancia_del_centro <= 40.0:
		# Desbalance moderado (entre 10-24 o 76-90)
		animated_sprite.play("3")
	else:
		# Desbalance crítico (menor a 10 o mayor a 90, al borde de perder)
		animated_sprite.play("4")
