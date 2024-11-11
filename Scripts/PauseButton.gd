extends TextureButton

# Carga la escena SplashScreen
var splashScreen = preload('res://Scenes/SplashScreen.tscn')

func _pressed():
	# Pausar el juego y mostrar el menú de niveles
	if !get_tree().is_paused():
		get_tree().set_pause(true)
		var menu = splashScreen.instance()
		get_tree().get_root().add_child(menu)
	else:
		# Si el juego está pausado, reanudarlo y ocultar el menú
		get_tree().set_pause(false)
		LevelManager.change_level(GameManager.cards_count)  # Cambia el nivel solo si es necesario
