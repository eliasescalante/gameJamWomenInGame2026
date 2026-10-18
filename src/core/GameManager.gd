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
var pensamiento_activo: Node = null 
var timer_notificaciones: Timer = null 
var nivel_activo: Node2D = null # Referencia al Nivel para comunicarse con los íconos

# Banco de notificaciones y dilemas (20 preguntas en total)
var lista_preguntas: Array = [
	{
		"frase": "¿Vas a ver a mamá?",
		"si": 12,
		"no": -12,
		"res_si": "Mamá se alegra. Siento un poco de paz.",
		"res_no": "Siento culpa por no haber ido..."
	},
	{
		"frase": "¿Trabajar horas extras para tu jefe?",
		"si": -10,
		"no": 10,
		"res_si": "El cansancio me consume... Necesito parar.",
		"res_no": "Me pongo firme con mi tiempo personal."
	},
	{
		"frase": "¿Salir a tomar algo con amigos?",
		"si": 10,
		"no": -10,
		"res_si": "Nos reímos bastante. Me despejó la cabeza.",
		"res_no": "Me aíslo otra vez en mi cuarto..."
	},
	{
		"frase": "¿Avanzar con la entrega de la Game Jam?",
		"si": 15,
		"no": -15,
		"res_si": "¡Tengo un boost de motivación y foco!",
		"res_no": "Empiezo a dudar de si voy a llegar a tiempo."
	},
	{
		"frase": "¿Refactorizar todo el código a las 3 AM?",
		"si": -15,
		"no": 15,
		"res_si": "Rompí todo... No me responden las neuronas.",
		"res_no": "Mejor lo dejo para mañana con la cabeza fría."
	},
	{
		"frase": "¿Atender la llamada de urgencia de un cliente?",
		"si": -12,
		"no": 12,
		"res_si": "Un estrés tremendo fuera de horario.",
		"res_no": "Pongo un límite saludable a mi trabajo."
	},
	{
		"frase": "¿Probar el bug que reportó un playtester de la jam?",
		"si": 10,
		"no": -10,
		"res_si": "¡Era algo tonto! Se arregló rápido.",
		"res_no": "Ese bug me va a comer la cabeza en la entrega."
	},
	{
		"frase": "¿Revisar los mails de trabajo durante el fin de semana?",
		"si": -10,
		"no": 10,
		"res_si": "Aparece un problema más para preocuparme...",
		"res_no": "Desconecto el teléfono. Mi descanso importa."
	},
	{
		"frase": "¿Diseñar una mecánica extra que no estaba planificada?",
		"si": -12,
		"no": 12,
		"res_si": "El feature creep me abruma...",
		"res_no": "Mantengo el alcance simple y realizable."
	},
	{
		"frase": "¿Parar a cocinar algo nutritivo?",
		"si": 12,
		"no": -12,
		"res_si": "Comer bien me devuelve la energía.",
		"res_no": "Sigo a mate y galletitas... me duele el estómago."
	},
	{
		"frase": "¿Dormir al menos 6 horas esta noche?",
		"si": 15,
		"no": -15,
		"res_si": "Un descanso reparador. Mañana rindo mejor.",
		"res_no": "La cabeza me retumba del insomnio..."
	},
	{
		"frase": "¿Pedir comida rápida por tercera vez consecutiva?",
		"si": -10,
		"no": 10,
		"res_si": "Pesadez total... Me siento lento.",
		"res_no": "Ahorro plata y me cuido un poco más."
	},
	{
		"frase": "¿Hacer una pausa de 10 minutos para estirar las piernas?",
		"si": 10,
		"no": -10,
		"res_si": "Se me alivia la tensión en la espalda.",
		"res_no": "Estoy todo contracturado frente a la pantalla."
	},
	{
		"frase": "¿Responder el mensaje de tu pareja?",
		"si": 12,
		"no": -12,
		"res_si": "Un gesto cariñoso que me reconforta.",
		"res_no": "Se nota la distancia entre nosotros..."
	},
	{
		"frase": "¿Mirar las redes sociales para ver qué hacen los demás en la jam?",
		"si": -10,
		"no": 8,
		"res_si": "Compararme con otros me genera ansiedad.",
		"res_no": "Me enfoco en mi propio proyecto sin presiones."
	},
	{
		"frase": "¿Pagar la boleta de luz que vence hoy?",
		"si": 12,
		"no": -12,
		"res_si": "Un peso menos de encima.",
		"res_no": "Pendientes juntando polvo en la cabeza..."
	},
	{
		"frase": "¿Ayudar a un compañero de la jam con un script en Discord?",
		"si": 8,
		"no": -8,
		"res_si": "Se siente lindo dar una mano a la comunidad.",
		"res_no": "Me guardo para mí, pero me da algo de culpa."
	},
	{
		"frase": "¿Aceptar la reunión familiar del domingo?",
		"si": 12,
		"no": -12,
		"res_si": "Estar cerca de la familia me recarga la pila.",
		"res_no": "Priorizo estar a solas, aunque me lo reclamen."
	},
	{
		"frase": "¿Limpiar y ordenar el escritorio antes de seguir programando?",
		"si": 8,
		"no": -8,
		"res_si": "Un espacio limpio me da claridad mental.",
		"res_no": "El desorden alrededor refleja mi desorden interno."
	},
	{
		"frase": "¿Crear la portada e imágenes para la página de itch.io?",
		"si": 15,
		"no": -15,
		"res_si": "¡El juego ya va tomando forma real!",
		"res_no": "Tener la página vacía me da pánico."
	}
]


func registrar_nivel(
	nodo_pc: Control,
	nodo_avatar: Node2D,
	timer_notif: Timer,
	nodo_tunel: ColorRect = null,
	nodo_camara: Camera2D = null,
	nodo_pensamiento: Node = null,
	nodo_nivel: Node2D = null
) -> void:
	pc_activa = nodo_pc
	avatar_activo = nodo_avatar
	efecto_tunel_activo = nodo_tunel
	camara_activa = nodo_camara
	pensamiento_activo = nodo_pensamiento
	timer_notificaciones = timer_notif
	nivel_activo = nodo_nivel

	puntaje_balance = 50
	indice_pregunta = 0
	lista_preguntas.shuffle()

	if pc_activa and not pc_activa.respuesta_elegida.is_connected(_on_respuesta_pc_recibida):
		pc_activa.respuesta_elegida.connect(_on_respuesta_pc_recibida)

	if timer_notificaciones and not timer_notificaciones.timeout.is_connected(_enviar_siguiente_mensaje):
		timer_notificaciones.timeout.connect(_enviar_siguiente_mensaje)
		timer_notificaciones.start(3.5)

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
		pc_activa.mostrar_pregunta(pregunta["frase"], pregunta["si"], pregunta["no"], pregunta["res_si"], pregunta["res_no"])

func _on_respuesta_pc_recibida(frase: String, valor: int, texto_pensamiento: String = "") -> void:
	if timer_notificaciones:
		timer_notificaciones.stop()

	puntaje_balance = clamp(puntaje_balance + valor, 0, 100)
	print("Frase: ", frase, " | Modificador: ", valor, " | Balance actual: ", puntaje_balance, " | Pensamiento: ", texto_pensamiento)
	
	if pensamiento_activo and pensamiento_activo.has_method("mostrar_pensamiento"):
		pensamiento_activo.mostrar_pensamiento(texto_pensamiento)
	
	balance_actualizado.emit(puntaje_balance)
	if avatar_activo:
		avatar_activo._on_puntaje_cambiado(puntaje_balance)
		
	_actualizar_efecto_visual()
	indice_pregunta += 1
	
	if puntaje_balance <= 0 or puntaje_balance >= 100:
		_derrota()
		return

	if is_inside_tree():
		get_tree().create_timer(3.0).timeout.connect(func():
			if timer_notificaciones and is_inside_tree():
				timer_notificaciones.start(3.5)
		)

func _actualizar_efecto_visual() -> void:
	if not efecto_tunel_activo:
		return
		
	var distancia_del_centro: float = abs(puntaje_balance - 50.0)
	var margen_seguro: float = 15.0 
	var nivel_tunel: float = 0.0
	
	if distancia_del_centro > margen_seguro:
		var exceso: float = distancia_del_centro - margen_seguro
		var factor_lineal: float = exceso / (50.0 - margen_seguro)
		nivel_tunel = pow(factor_lineal, 1.8)
	
	# --- CONTROL DE MÚSICA DINÁMICA CON EL AUDIOMANAGER ---
	if distancia_del_centro > margen_seguro:
		if AudioManager.calma.playing:
			AudioManager.stop_calma()
		if not AudioManager.peligro.playing:
			AudioManager.play_peligro()
			
		# Notificamos al Nivel para acumular íconos translúcidos
		if nivel_activo and nivel_activo.has_method("activar_peligro_iconos"):
			nivel_activo.activar_peligro_iconos()
	else:
		if AudioManager.peligro.playing:
			AudioManager.stop_peligro()
		if not AudioManager.calma.playing:
			AudioManager.play_calma()
			
		# Notificamos al Nivel para limpiar íconos 1 a 1
		if nivel_activo and nivel_activo.has_method("activar_calma_iconos"):
			nivel_activo.activar_calma_iconos()
	# ------------------------------------------------------
	
	if efecto_tunel_activo.has_method("actualizar_efecto_tunel"):
		efecto_tunel_activo.actualizar_efecto_tunel(nivel_tunel)
		
	if camara_activa and camara_activa.has_method("establecer_intensidad_pulsacion"):
		camara_activa.establecer_intensidad_pulsacion(nivel_tunel)

func _evaluar_final_juego() -> void:
	AudioManager.stop_calma()
	AudioManager.stop_peligro()
	
	if puntaje_balance > 20 and puntaje_balance < 80:
		_victoria()
	else:
		_derrota()

func _victoria() -> void:
	gano = true
	get_tree().change_scene_to_file("res://src/scenes/WinLose/WinLose.tscn")

func _derrota() -> void:
	gano = false
	get_tree().change_scene_to_file("res://src/scenes/WinLose/WinLose.tscn")
