extends PanelContainer

# Señal que emite la frase respondida, el valor asignado y el texto del pensamiento
signal respuesta_elegida(frase: String, valor: int, texto_pensamiento: String)

# Referencias a la interfaz principal
@onready var label_mensaje: Label = $MarginContainer/VBoxContainer/Label
@onready var boton_si: Button = $MarginContainer/VBoxContainer/HBoxContainer/SI
@onready var boton_no: Button = $MarginContainer/VBoxContainer/HBoxContainer/NO

# Referencias al globo de pensamiento
@onready var globo_pensamiento: Control = $GloboPensamiento
@onready var label_pensamiento: Label = $GloboPensamiento/LabelPensamiento

# Referencia a la campana
@onready var campana: Sprite2D = $Campana

# Variables de estado
var frase_actual: String = ""
var valor_si_actual: int = 0
var valor_no_actual: int = 0
var res_si_actual: String = ""
var res_no_actual: String = ""

var token_pregunta: int = 0
var tween_bamboleo: Tween = null

func _ready() -> void:
	_estado_sin_mensajes()

func mostrar_pregunta(frase: String, v_si: int, v_no: int, r_si: String = "", r_no: String = "") -> void:
	token_pregunta += 1
	
	frase_actual = frase
	valor_si_actual = v_si
	valor_no_actual = v_no
	res_si_actual = r_si
	res_no_actual = r_no
	
	label_mensaje.text = frase
	label_mensaje.modulate = Color.WHITE
	label_mensaje.scale = Vector2.ONE
	
	# Ocultar el globo de pensamiento al recibir una pregunta nueva
	if globo_pensamiento:
		globo_pensamiento.visible = false
	
	boton_si.disabled = false
	boton_no.disabled = false
	boton_si.visible = true
	boton_no.visible = true
	
	_activar_campana()

func _on_si_pressed() -> void:
	_bloquear_interfaz()
	_ocultar_campana()
	
	label_mensaje.text = frase_actual + "  [✓]"
	_animar_respuesta(Color(0.3, 1.0, 0.3))
	
	# Mostrar el globo de texto con el pensamiento positivo/SÍ
	_mostrar_pensamiento(res_si_actual)
	
	respuesta_elegida.emit(frase_actual, valor_si_actual, res_si_actual)
	_programar_limpieza_pantalla()

func _on_no_pressed() -> void:
	_bloquear_interfaz()
	_ocultar_campana()
	
	label_mensaje.text = frase_actual + "  [✕]"
	_animar_respuesta(Color(1.0, 0.3, 0.3))
	
	# Mostrar el globo de texto con el pensamiento negativo/NO
	_mostrar_pensamiento(res_no_actual)
	
	respuesta_elegida.emit(frase_actual, valor_no_actual, res_no_actual)
	_programar_limpieza_pantalla()

# --- Mostrar/Ocultar el Globo de Pensamiento ---

func _mostrar_pensamiento(texto: String) -> void:
	if globo_pensamiento and label_pensamiento and not texto.is_empty():
		label_pensamiento.text = texto
		globo_pensamiento.visible = true
		
		# Opcional: Pequeña animación de escala para que aparezca rebotando
		globo_pensamiento.scale = Vector2(0.8, 0.8)
		var tween = create_tween()
		tween.tween_property(globo_pensamiento, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _programar_limpieza_pantalla() -> void:
	var token_actual = token_pregunta
	if is_inside_tree():
		# Damos 3 segundos para que el jugador lea el pensamiento en el globo
		var timer = get_tree().create_timer(3.0)
		timer.timeout.connect(func():
			if token_pregunta == token_actual:
				_estado_sin_mensajes()
		)

# --- Animaciones auxiliares ---

func _activar_campana() -> void:
	if not campana:
		return
	campana.visible = true
	campana.rotation_degrees = 0.0
	
	if tween_bamboleo and tween_bamboleo.is_running():
		tween_bamboleo.kill()
		
	tween_bamboleo = create_tween().set_loops()
	tween_bamboleo.tween_property(campana, "rotation_degrees", 12.0, 0.15).set_trans(Tween.TRANS_SINE)
	tween_bamboleo.tween_property(campana, "rotation_degrees", -12.0, 0.3).set_trans(Tween.TRANS_SINE)
	tween_bamboleo.tween_property(campana, "rotation_degrees", 0.0, 0.15).set_trans(Tween.TRANS_SINE)
	tween_bamboleo.tween_interval(0.4)

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
	boton_si.disabled = true
	boton_no.disabled = true

func _estado_sin_mensajes() -> void:
	_ocultar_campana()
	
	label_mensaje.text = "mensaje: 0"
	label_mensaje.modulate = Color(0.7, 0.7, 0.7, 0.8)
	label_mensaje.scale = Vector2.ONE
	
	if globo_pensamiento:
		globo_pensamiento.visible = false
		
	boton_si.visible = false
	boton_no.visible = false
