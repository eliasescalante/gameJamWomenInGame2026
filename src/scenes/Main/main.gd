extends Control

func _on_button_pressed() -> void:
	#voy al nivel
	get_tree().change_scene_to_file("res://src/scenes/Nivel/Nivel.tscn")


func _on_button_2_pressed() -> void:
	#abro creditos
	get_tree().change_scene_to_file("res://src/scenes/Creditos/Creditos.tscn")


func _on_button_3_pressed() -> void:
	#cierro el juego
	get_tree().quit()
