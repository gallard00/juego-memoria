extends TextureButton

var splashScreen = preload('res://Scenes/SplashScreen.tscn')

func _ready():
	# Conectar el botón de menú a la función on_menu_button_pressed
	$Panel/Sections/VBoxContainer/MenuButton.connect("pressed", self, "_on_MenuButton_pressed")


func _on_MenuButton_pressed():
	# Pausar el juego
	get_tree().paused = true  

	# Verificamos si el nodo "Game" existe antes de llamar a resetGame
	var game_node = get_parent().get_node("Game")
	if is_instance_valid(game_node):
		game_node.resetGame()  # Reiniciamos el juego para liberar recursos.
	
	# Cambiar a la escena de selección de nivel (SplashScreen)
	get_tree().change_scene("res://Scenes/SplashScreen.tscn")  
	pass # Replace with function body.
