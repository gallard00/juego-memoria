extends TextureButton


func _ready():
	# Inicialización de la escena (actualmente vacía)
	pass

# Función que se ejecuta cuando el botón es presionado
func _pressed():
	if !get_tree().is_paused():
		# Si el juego no está pausado, lo pausamos y cambiamos la textura a "play"
		get_tree().set_pause(true)
		set_normal_texture(load("res://Assets-Memorization/ui/play.png"))
	else:
		# Si el juego está pausado, lo reanudamos y cambiamos la textura a "pause"
		get_tree().set_pause(false)
		set_normal_texture(load("res://Assets-Memorization/ui/pause.png"))
