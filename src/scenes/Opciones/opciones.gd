extends Control

@onready var slider_music: HSlider = $Panel/Music
@onready var slider_sfx: HSlider = $Panel/SFX

var bus_music_idx: int
var bus_sfx_idx: int

func _ready() -> void:
	bus_music_idx = AudioServer.get_bus_index("Music")
	bus_sfx_idx = AudioServer.get_bus_index("SFX")
	
	# Como el Max Value es 100, la mitad exacta es 50
	var volumen_inicial: float = 50.0
	
	if slider_music:
		slider_music.value = volumen_inicial
		slider_music.value_changed.connect(_on_slider_music_value_changed)
	
	if slider_sfx:
		slider_sfx.value = volumen_inicial
		slider_sfx.value_changed.connect(_on_slider_sfx_value_changed)
		
	# Aplicamos el volumen inicial convirtiendo el rango 0-100 a escala lineal (0.0 a 1.0)
	AudioServer.set_bus_volume_db(bus_music_idx, linear_to_db(volumen_inicial / 100.0))
	AudioServer.set_bus_volume_db(bus_sfx_idx, linear_to_db(volumen_inicial / 100.0))

func _on_slider_music_value_changed(value: float) -> void:
	# Dividimos entre 100 para que pase de un rango (0 - 100) a (0.0 - 1.0)
	var valor_linear: float = value / 100.0
	AudioServer.set_bus_volume_db(bus_music_idx, linear_to_db(valor_linear))
	AudioServer.set_bus_mute(bus_music_idx, valor_linear <= 0.0)

func _on_slider_sfx_value_changed(value: float) -> void:
	var valor_linear: float = value / 100.0
	AudioServer.set_bus_volume_db(bus_sfx_idx, linear_to_db(valor_linear))
	AudioServer.set_bus_mute(bus_sfx_idx, valor_linear <= 0.0)


func _on_button_3_pressed() -> void:
	AudioManager.play_sfx_click()
	get_tree().change_scene_to_file("res://src/scenes/Main/Main.tscn")
	pass # Replace with function body.
