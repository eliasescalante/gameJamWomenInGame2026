extends PanelContainer

# Señal que emite la frase respondida y el valor asignado a la respuesta elegida
signal respuesta_elegida(frase: String, valor: int)

# Referencias a los nodos de la interfaz
@onready var label_mensaje: Label = $MarginContainer/VBoxContainer/Label
@onready var boton_si: Button = $MarginContainer/VBoxContainer/HBoxContainer/SI
@onready var boton_no: Button = $MarginContainer/VBoxContainer/HBoxContainer/NO

# Referencia al nodo de la campana que agregaste en la escena PC
@onready var campana: Sprite2D = $Campana

# Variables para mantener el estado de la pregunta activa
var frase_actual: String = ""
var valor_si: int = 0
var valor_no: int = 0
var token_pregunta: int = 0 # Identificador para evitar solapamiento de notificaciones

# Tween para controlar la animación de bamboleo de la campana
var tween_bamboleo: Tween = null

func _ready() -> void:
	# Al arrancar la escena, mostramos que no hay mensajes entrantes
	_estado_sin_mensajes()

func mostrar_pregunta(frase: String, v_si: int, v_no: int) -> void:
	# Incrementamos el token cada vez que llega una nueva pregunta para cancelar la limpieza anterior
	token_pregunta += 1
	
	# 1. Guardamos los datos para usarlos al presionar los botones
	frase_actual = frase
	valor_si = v_si
	valor_no = v_no
	
	# 2. Mostramos el mensaje y reactivamos los botones
	label_mensaje.text = frase
	label_mensaje.modulate = Color.WHITE
	label_mensaje.scale = Vector2.ONE
	
	boton_si.disabled = false
	boton_no.disabled = false
	boton_si.visible = true
	boton_no.visible = true
	
	# 3. Activamos la campana y su bamboleo de notificación entrante
	_activar_campana()

func _on_si_pressed() -> void:
	_bloquear_interfaz()
	_ocultar_campana() # La campana desaparece al responder
	
	label_mensaje.text = frase_actual + "  [✓]"
	_animar_respuesta(Color(0.3, 1.0, 0.3))
	
	# Emitimos la respuesta al GameManager
	respuesta_elegida.emit(frase_actual, valor_si)
	
	# Guardamos el token actual
	var token_actual = token_pregunta
	
	# Verificamos que el nodo siga en el árbol antes de crear el timer (evita el error si cambió de escena)
	if is_inside_tree():
		get_tree().create_timer(0.8).timeout.connect(func():
			# Solo pasa a "Mensajes: 0" si NO llegó una pregunta nueva en esos 0.8 segundos
			if token_pregunta == token_actual:
				_estado_sin_mensajes()
		)

func _on_no_pressed() -> void:
	_bloquear_interfaz()
	_ocultar_campana() # La campana desaparece al responder
	
	label_mensaje.text = frase_actual + "  [✕]"
	_animar_respuesta(Color(1.0, 0.3, 0.3))
	
	# Emitimos la respuesta al GameManager
	respuesta_elegida.emit(frase_actual, valor_no)
	
	# Guardamos el token actual
	var token_actual = token_pregunta
	
	# Verificamos que el nodo siga en el árbol antes de crear el timer
	if is_inside_tree():
		get_tree().create_timer(0.8).timeout.connect(func():
			# Solo pasa a "Mensajes: 0" si NO llegó una pregunta nueva en esos 0.8 segundos
			if token_pregunta == token_actual:
				_estado_sin_mensajes()
		)

# --- Métodos de Animación y Control de la Campana ---

func _activar_campana() -> void:
	if not campana:
		return
		
	campana.visible = true
	campana.rotation_degrees = 0.0
	
	# Si ya había un bamboleo corriendo, lo matamos para reiniciar limpio
	if tween_bamboleo and tween_bamboleo.is_running():
		tween_bamboleo.kill()
		
	# Creamos el bamboleo en bucle infinito mientras la pregunta esté activa
	tween_bamboleo = create_tween().set_loops()
	tween_bamboleo.tween_property(campana, "rotation_degrees", 12.0, 0.15).set_trans(Tween.TRANS_SINE)
	tween_bamboleo.tween_property(campana, "rotation_degrees", -12.0, 0.3).set_trans(Tween.TRANS_SINE)
	tween_bamboleo.tween_property(campana, "rotation_degrees", 0.0, 0.15).set_trans(Tween.TRANS_SINE)
	tween_bamboleo.tween_interval(0.4) # Pausa breve entre sacudidas

func _ocultar_campana() -> void:
	if tween_bamboleo and tween_bamboleo.is_running():
		tween_bamboleo.kill()
	if campana:
		campana.visible = false
		campana.rotation_degrees = 0.0

func _animar_respuesta(color_flash: Color) -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(label_mensaje, "modulate", color_flash, 0.15)
	tween.tween_property(label_mensaje, "scale", Vector2(1.03, 1.03), 0.15)
	
	tween.chain().tween_property(label_mensaje, "scale", Vector2.ONE, 0.1)

func _bloquear_interfaz() -> void:
	# Desactivamos botones para evitar spamear clics mientras procesa
	boton_si.disabled = true
	boton_no.disabled = true

func _estado_sin_mensajes() -> void:
	# Aseguramos que la campana esté oculta cuando no hay mensajes
	_ocultar_campana()
	
	# Limpia la pantalla mientras se espera la siguiente notificación del Timer
	label_mensaje.text = "mensaje: 0"
	label_mensaje.modulate = Color(0.7, 0.7, 0.7, 0.8) # Gris tenue
	label_mensaje.scale = Vector2.ONE
	boton_si.visible = false
	boton_no.visible = false
