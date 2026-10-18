extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# 1. Obtener todas las animaciones disponibles en el AnimatedSprite2D
	var nombres_animaciones = animated_sprite.sprite_frames.get_animation_names()
	
	if not nombres_animaciones.is_empty():
		# Seleccionar una animación al azar de las 10 disponibles
		var anim_aleatoria = nombres_animaciones[randi() % nombres_animaciones.size()]
		animated_sprite.play(anim_aleatoria)
	
	# 2. Hacer el ícono semitransparente (translúcido)
	modulate.a = 0.35
	
	# 3. Animación suave de aparición
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
