extends Node2D

@onready var peligro: AudioStreamPlayer = $Peligro
@onready var calma: AudioStreamPlayer = $calma

func _ready() -> void:
	# Arrancamos el nivel con música de calma por defecto
	play_calma()

func play_peligro():
	if not peligro.playing:
		peligro.play()

func stop_peligro():
	peligro.stop()

func play_calma():
	if not calma.playing:
		calma.play()

func stop_calma():
	calma.stop()
