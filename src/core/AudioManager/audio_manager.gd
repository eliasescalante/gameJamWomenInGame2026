extends Node2D

@onready var peligro: AudioStreamPlayer = $Peligro
@onready var calma: AudioStreamPlayer = $calma
@onready var sfx_rechazar: AudioStreamPlayer = $SFX/SfxRechazar
@onready var sfx_click: AudioStreamPlayer = $SFX/SfxClick
@onready var sfx_notificacion: AudioStreamPlayer = $SFX/SfxNotificacion
@onready var sfx_aceptar: AudioStreamPlayer = $SFX/SfxAceptar

func _ready() -> void:
	# Arrancamos el nivel con música de calma por defecto
	play_calma()

# --- MÚSICA AMBIENTAL ---

func play_peligro() -> void:
	if peligro and not peligro.playing:
		peligro.play()

func stop_peligro() -> void:
	if peligro and peligro.playing:
		peligro.stop()

func play_calma() -> void:
	if calma and not calma.playing:
		calma.play()

func stop_calma() -> void:
	if calma and calma.playing:
		calma.stop()

# --- EFECTOS DE SONIDO (SFX) ---

func play_sfx_rechazar() -> void:
	if sfx_rechazar:
		sfx_rechazar.play()

func stop_sfx_rechazar() -> void:
	if sfx_rechazar and sfx_rechazar.playing:
		sfx_rechazar.stop()

func play_sfx_click() -> void:
	if sfx_click:
		sfx_click.play()

func stop_sfx_click() -> void:
	if sfx_click and sfx_click.playing:
		sfx_click.stop()

func play_sfx_notificacion() -> void:
	if sfx_notificacion:
		sfx_notificacion.play()

func stop_sfx_notificacion() -> void:
	if sfx_notificacion and sfx_notificacion.playing:
		sfx_notificacion.stop()

func play_sfx_aceptar() -> void:
	if sfx_aceptar:
		sfx_aceptar.play()

func stop_sfx_aceptar() -> void:
	if sfx_aceptar and sfx_aceptar.playing:
		sfx_aceptar.stop()
