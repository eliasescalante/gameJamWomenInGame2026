extends Node

# Señales globales que pueden escuchar otros scripts
signal balance_actualizado(nuevo_puntaje: int)

# Variables globales de estado (arranca en 50 para estar en el centro exacto del rango 0 a 100)
var puntaje_balance: int = 50
var indice_pregunta: int = 0
var gano: bool = false

# Referencias directas a los nodos activos en la escena
var pc_activa: Control = null
var avatar_activo: Node2D = null
var efecto_tunel_activo: ColorRect = null
var camara_activa: Camera2D = null

# Banco de notificaciones y dilemas (20 preguntas en total)
var lista_preguntas: Array = [
	# --- Preguntas iniciales ---
	{
		"frase": "¿Vas a ver a mamá?",
		"si": 12,
		"no": -12
	},
	{
		"frase": "¿Trabajar horas extras para tu jefe?",
		"si": -10,
		"no": 10
	},
	{
		"frase": "¿Salir a tomar algo con amigos?",
		"si": 10,
		"no": -10
	},
	{
		"frase": "¿Avanzar con la entrega de la Game Jam?",
		"si": 15,
		"no": -15
	},
	
	# --- Dilemas laborales y de desarrollo ---
	{
		"frase": "¿Refactorizar todo el código a las 3 AM?",
		"si": -15,
		"no": 15
	},
	{
		"frase": "¿Atender la llamada de urgencia de un cliente?",
		"si": -12,
		"no": 12
	},
	{
		"frase": "¿Probar el bug que reportó un playtester de la jam?",
		"si": 10,
		"no": -10
	},
	{
		"frase": "¿Revisar los mails de trabajo durante el fin de semana?",
		"si": -10,
		"no": 10
	},
	{
		"frase": "¿Diseñar una mecánica extra que no estaba planificada?",
		"si": -12,
		"no": 12
	},
	
	# --- Salud, bienestar y vida personal ---
	{
		"frase": "¿Parar a cocinar algo nutritivo?",
		"si": 12,
		"no": -12
	},
	{
		"frase": "¿Dormir al menos 6 horas esta noche?",
		"si": 15,
		"no": -15
	},
	{
		"frase": "¿Pedir comida rápida por tercera vez consecutiva?",
		"si": -10,
		"no": 10
	},
	{
		"frase": "¿Hacer una pausa de 10 minutos para estirar las piernas?",
		"si": 10,
		"no": -10
	},
	{
		"frase": "¿Responder el mensaje de tu pareja?",
		"si": 12,
		"no": -12
	},
	
	# --- Redes, distracciones y presión social ---
	{
		"frase": "¿Mirar las redes sociales para ver qué hacen los demás en la jam?",
		"si": -10,
		"no": 8
	},
	{
		"frase": "¿Pagar la boleta de luz que vence hoy?",
		"si": 12,
		"no": -12
	},
	{
		"frase": "¿Ayudar a un compañero de la jam con un script en Discord?",
		"si": 8,
		"no": -8
	},
	{
		"frase": "¿Aceptar la reunión familiar del domingo?",
		"si": 12,
		"no": -12
	},
	{
		"frase": "¿Limpiar y ordenar el escritorio antes de seguir programando?",
		"si": 8,
		"no": -8
	},
	{
		"frase": "¿Crear la portada e imágenes para la página de itch.io?",
		"si": 15,
		"no": -15
	}
]

# Método que llama la escena 'Nivel' al cargarse para registrar las referencias
func registrar_nivel(nodo_pc: Control, nodo_avatar: Node2D, timer_notif: Timer, nodo_tunel: ColorRect = null, nodo_camara: Camera2D = null) -> void:
	pc_activa = nodo_pc
	avatar_activo = nodo_avatar
	efecto_tunel_activo = nodo_tunel
	camara_activa = nodo_camara
	
	# Reiniciamos variables de estado para la partida y barajamos preguntas
	puntaje_balance = 50
	indice_pregunta = 0
	lista_preguntas.shuffle()
	
	if pc_activa and not pc_activa.respuesta_elegida.is_connected(_on_respuesta_pc_recibida):
		pc_activa.respuesta_elegida.connect(_on_respuesta_pc_recibida)
	
	if timer_notif and not timer_notif.timeout.is_connected(_enviar_siguiente_mensaje):
		timer_notif.timeout.connect(_enviar_siguiente_mensaje)
		timer_notif.start(3.5)

	if avatar_activo:
		avatar_activo._on_puntaje_cambiado(puntaje_balance)
		
	_actualizar_efecto_visual()


func _enviar_siguiente_mensaje() -> void:
	if indice_pregunta >= lista_preguntas.size():
		print("¡No hay más notificaciones por ahora!")
		_evaluar_final_juego()
		return

	var pregunta = lista_preguntas[indice_pregunta]
	if pc_activa:
		pc_activa.mostrar_pregunta(pregunta["frase"], pregunta["si"], pregunta["no"])


func _on_respuesta_pc_recibida(frase: String, valor: int) -> void:
	puntaje_balance = clamp(puntaje_balance + valor, 0, 100)
	print("Frase: ", frase, " | Modificador: ", valor, " | Balance actual: ", puntaje_balance)
	
	balance_actualizado.emit(puntaje_balance)
	if avatar_activo:
		avatar_activo._on_puntaje_cambiado(puntaje_balance)
		
	_actualizar_efecto_visual()
	indice_pregunta += 1
	
	if puntaje_balance <= 0 or puntaje_balance >= 100:
		_derrota()


func _actualizar_efecto_visual() -> void:
	if not efecto_tunel_activo:
		return
		
	# Distancia absoluta desde el centro exacto (50) -> Rango de 0.0 a 50.0
	var distancia_del_centro: float = abs(puntaje_balance - 50.0)
	
	# Mantenemos la zona muerta (deadzone) de 15 puntos (35 a 65)
	var margen_seguro: float = 15.0 
	var nivel_tunel: float = 0.0
	
	if distancia_del_centro > margen_seguro:
		var exceso: float = distancia_del_centro - margen_seguro
		var factor_lineal: float = exceso / (50.0 - margen_seguro)
		nivel_tunel = pow(factor_lineal, 1.8) # Curva suave
	
	print("Balance: ", puntaje_balance, " | Intensidad estrés: ", nivel_tunel)
	
	# Actualizamos el shader del túnel (viñeta negra)
	if efecto_tunel_activo.has_method("actualizar_efecto_tunel"):
		efecto_tunel_activo.actualizar_efecto_tunel(nivel_tunel)
		
	# Sincronizamos el latido rítmico de la cámara con el nivel de estrés
	# ¡Cambiamos el nombre del método!
	if camara_activa and camara_activa.has_method("establecer_intensidad_pulsacion"):
		camara_activa.establecer_intensidad_pulsacion(nivel_tunel)


func _evaluar_final_juego() -> void:
	# Condición de victoria: si al terminar las preguntas está dentro del margen seguro
	if puntaje_balance > 20 and puntaje_balance < 80:
		print("¡VICTORIA! Lograste entregar el juego para la Jam.")
		_victoria()
	else:
		_derrota()


func _victoria() -> void:
	gano = true
	get_tree().change_scene_to_file("res://src/scenes/WinLose/WinLose.tscn")


func _derrota() -> void:
	print("¡DERROTA! Te abrumaste por completo o te aislaste demasiado.")
	gano = false
	get_tree().change_scene_to_file("res://src/scenes/WinLose/WinLose.tscn")
