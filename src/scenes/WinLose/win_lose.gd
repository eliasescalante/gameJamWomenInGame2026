extends Control

@onready var label_mensaje: Label = $PanelContainer/HBoxContainer/LabelMensaje
@onready var boton_reintentar: Button = $PanelContainer/HBoxContainer/HBoxContainer/BotonReintentar

# Referencias a los fondos y al video
@onready var fondo_win: Sprite2D = $FondoWin
@onready var fondo_lose: Sprite2D = $FondoLose
@onready var video_player: VideoStreamPlayer = $FondoWin/VideoStreamPlayer # Ajusta la ruta si pusiste el nodo en otro lugar

func _ready() -> void:
	# Leemos el estado desde el GameManager
	if GameManager.gano:
		label_mensaje.text = "Por fin pude terminar mi proyecto, a veces hay que aprender a decir que NO."
		
		# Mostramos el fondo de victoria y ocultamos el de derrota
		fondo_win.visible = true
		fondo_lose.visible = false
		
		# Reproducimos el video dentro del monitor
		if video_player:
			video_player.play()
	else:
		label_mensaje.text = "No pude terminar mi proyecto...tengo que aprender a decir que NO a ciertas cosas."
		
		# Mostramos el fondo de derrota y ocultamos el de victoria
		fondo_win.visible = false
		fondo_lose.visible = true
		
		# Aseguramos que el video esté detenido
		if video_player:
			video_player.stop()

func _on_boton_reintentar_pressed() -> void:
	AudioManager.play_sfx_click()
	# Reiniciamos las variables del Autoload GameManager
	GameManager.puntaje_balance = 50
	GameManager.indice_pregunta = 0
	
	# Cambiamos a la escena del Nivel
	get_tree().change_scene_to_file("res://src/scenes/Nivel/Nivel.tscn")
