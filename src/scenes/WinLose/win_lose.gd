extends Control

@onready var label_mensaje: Label = $PanelContainer/HBoxContainer/LabelMensaje
@onready var boton_reintentar: Button = $PanelContainer/HBoxContainer/HBoxContainer/BotonReintentar

func _ready() -> void:
	# Leemos el estado desde el GameManager
	if GameManager.gano:
		label_mensaje.text = "EXITO! Lograste equilibrar tus responsabilidades y entregar tu juego."
	else:
		label_mensaje.text = "Estás abrumado... El estrés te superó y no pudiste terminar el proyecto."

func _on_boton_reintentar_pressed() -> void:
	# Reiniciamos las variables del Autoload GameManager
	GameManager.puntaje_balance = 20
	GameManager.indice_pregunta = 0
	
	# Cambiamos a la escena del Nivel
	get_tree().change_scene_to_file("res://src/scenes/Nivel/Nivel.tscn")
