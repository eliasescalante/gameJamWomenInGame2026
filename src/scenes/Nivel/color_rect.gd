extends ColorRect

# Función pública para ajustar la oscuridad del túnel de 0.0 (normal) a 1.0 (muy cerrado)
func actualizar_efecto_tunel(nivel_estres: float) -> void:
	# Aseguramos que el valor esté acotado entre 0.0 y 1.0
	var intensidad_calculada = clamp(nivel_estres, 0.0, 1.0)
	
	# Le enviamos el valor al parámetro 'intensidad' de nuestro Shader Material
	material.set_shader_parameter("intensidad", intensidad_calculada)
