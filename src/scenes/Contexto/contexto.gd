extends Control

@onready var color_rect = $ColorRect # Reemplaza con la ruta correcta si lo pusiste en otra posición

func _ready() -> void:
	# Opcional: Aseguramos que empiece completamente negro (opaco)
	color_rect.modulate.a = 1.0
	
	# Creamos el Tween
	var tween = create_tween()
	
	# 1. FADE-IN: Se aclara de negro a transparente (duración: 2 segundos)
	tween.tween_property(color_rect, "modulate:a", 0.0, 2.0)
	
	# 2. Mantiene la pantalla visible un momento (opcional, o pasa directo al fade-out)
	# Si quieres que dure 4 segundos en total (2s de entrada y 2s de salida):
	tween.tween_property(color_rect, "modulate:a", 1.0, 2.0).set_delay(1)
	
	# 3. Al terminar la animación, puedes cambiar de escena o activar el nivel
	tween.tween_callback(_on_intro_finished)

func _on_intro_finished() -> void:
	print("La intro ha finalizado")
	# Ejemplo para cambiar de escena al terminar los 4 segundos:
	get_tree().change_scene_to_file("res://src/scenes/Nivel/Nivel.tscn")
