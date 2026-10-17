extends Control

# Señal que emite la frase respondida y el valor asignado a la respuesta elegida
signal respuesta_elegida(frase: String, valor: int)

# Referencias a los nodos de la interfaz según tu árbol
@onready var label_mensaje: Label = $PanelContainer/VBoxContainer/Label
@onready var boton_si: Button = $PanelContainer/VBoxContainer/HBoxContainer/SI
@onready var boton_no: Button = $PanelContainer/VBoxContainer/HBoxContainer/NO

# Variables para mantener el estado de la pregunta activa
var _frase_actual: String = ""
var _valor_si: int = 0
var _valor_no: int = 0


# Método público para que otro script le envíe los datos
func mostrar_pregunta(frase: String, valor_si: int, valor_no: int) -> void:
	_frase_actual = frase
	_valor_si = valor_si
	_valor_no = valor_no
	
	# Imprime la frase directamente en el Label
	label_mensaje.text = _frase_actual


func _on_si_pressed() -> void:
	if _frase_actual.is_empty():
		return
	
	# Emite la señal mandando la frase y el valor de la opción SÍ
	respuesta_elegida.emit(_frase_actual, _valor_si)


func _on_no_pressed() -> void:
	if _frase_actual.is_empty():
		return
	
	# Emite la señal mandando la frase y el valor de la opción NO
	respuesta_elegida.emit(_frase_actual, _valor_no)
