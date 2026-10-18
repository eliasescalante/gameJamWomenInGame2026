extends Control

@onready var label_texto: Label = $Label

func _ready() -> void:
	visible = false

func mostrar_pensamiento(texto: String) -> void:
	print(">>> ¡MOSTRANDO PENSAMIENTO EN PANTALLA! Texto: ", texto)
	
	if not label_texto:
		printerr("¡Error! Falta la referencia al Label dentro de Pensamientos.")
		return
		
	label_texto.text = texto
	visible = true
	
	# Guardamos el timer en una variable para evitar errores de sintaxis al encadenar
	var timer = get_tree().create_timer(3.5)
	timer.timeout.connect(_ocultar_pensamiento)

func _ocultar_pensamiento() -> void:
	visible = false
