extends Node

# Señales globales que pueden escuchar otros scripts
signal balance_actualizado(nuevo_puntaje: int)

# Variables globales de estado
var puntaje_balance: int = 20
var indice_pregunta: int = 0
var gano: bool = false

# Referencias directas a los nodos activos en la escena
var pc_activa: Control = null
var avatar_activo: Node2D = null

# Banco de notificaciones y dilemas
var lista_preguntas: Array = [
	{
		"frase": "¿Vas a ver a mamá?",
		"si": 15,
		"no": -15
	},
	{
		"frase": "¿Trabajar horas extras para tu jefe?",
		"si": -20,
		"no": 10
	},
	{
		"frase": "¿Salir a tomar algo con amigxs?",
		"si": 10,
		"no": -10
	},
	{
		"frase": "¿Avanzar con la entrega de la Game Jam?",
		"si": 15,
		"no": -20
	}
]

# Método que llama la escena 'Nivel' al cargarse para registrar las referencias
func registrar_nivel(nodo_pc: Control, nodo_avatar: Node2D, timer_notif: Timer) -> void:
	pc_activa = nodo_pc
	avatar_activo = nodo_avatar
	
	# Conectamos la señal que emite la PC cuando el usuario presiona un botón
	if pc_activa and not pc_activa.respuesta_elegida.is_connected(_on_respuesta_pc_recibida):
		pc_activa.respuesta_elegida.connect(_on_respuesta_pc_recibida)
	
	# Conectamos el Timer del nivel
	if timer_notif and not timer_notif.timeout.is_connected(_enviar_siguiente_mensaje):
		timer_notif.timeout.connect(_enviar_siguiente_mensaje)
		timer_notif.start(3.5) # Dispara un mensaje cada 3.5 segundos

	# Emitimos el puntaje inicial al Avatar
	if avatar_activo:
		avatar_activo._on_puntaje_cambiado(puntaje_balance)


func _enviar_siguiente_mensaje() -> void:
	if indice_pregunta >= lista_preguntas.size():
		print("¡No hay más notificaciones por ahora!")
		_evaluar_final_juego()
		return

	var pregunta = lista_preguntas[indice_pregunta]
	if pc_activa:
		pc_activa.mostrar_pregunta(pregunta["frase"], pregunta["si"], pregunta["no"])


func _on_respuesta_pc_recibida(frase: String, valor: int) -> void:
	# Actualizamos el balance global
	puntaje_balance += valor
	print("Frase: ", frase, " | Modificador: ", valor, " | Balance actual: ", puntaje_balance)
	
	# Emitimos señal y actualizamos directamente el Avatar
	balance_actualizado.emit(puntaje_balance)
	if avatar_activo:
		avatar_activo._on_puntaje_cambiado(puntaje_balance)
		
	# Avanzamos a la siguiente pregunta
	indice_pregunta += 1
	
	# Comprobamos condición de derrota por extremos
	if puntaje_balance <= 0 or puntaje_balance >= 60:
		_derrota()


func _evaluar_final_juego() -> void:
	if puntaje_balance > 10 and puntaje_balance < 50:
		print("¡VICTORIA! Lograste entregar el juego para la Jam.")
		_victoria()
	else:
		_derrota()

func _victoria():
	gano = true
	get_tree().change_scene_to_file("res://src/scenes/WinLose/WinLose.tscn")

func _derrota() -> void:
	print("¡DERROTA! Te abrumaste por completo o te aislaste demasiado.")
	gano = false
	get_tree().change_scene_to_file("res://src/scenes/WinLose/WinLose.tscn")
