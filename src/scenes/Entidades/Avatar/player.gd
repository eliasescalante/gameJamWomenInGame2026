extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $PanelContainer/AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play("1")

func _on_puntaje_cambiado(nuevo_puntaje: int) -> void:
	# Supongamos que esta función se ejecuta cuando se emite la señal de cambio de puntaje
	actualizar_animacion_por_puntaje(nuevo_puntaje)

func actualizar_animacion_por_puntaje(puntaje: int) -> void:
	# Evaluamos el puntaje por rangos y cambiamos la animación
	if puntaje < 10:
		animated_sprite.play("1")
	elif puntaje < 25:
		animated_sprite.play("2")
	elif puntaje < 50:
		animated_sprite.play("3")
	else:
		animated_sprite.play("4")
