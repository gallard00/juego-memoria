extends Control

func _ready():
	# Pausamos el juego al inicio
	get_tree().set_pause(true)
	
	# Conectamos cada botón a la función que selecciona la dificultad, pasando el número de pares de cartas
	$CenterContainer/Panel/VBoxContainer/easy.connect("pressed", self, "_on_difficulty_selected", [12])  # 12 pares para fácil
	$CenterContainer/Panel/VBoxContainer/normal.connect("pressed", self, "_on_difficulty_selected", [24]) # 24 pares para normal
	$CenterContainer/Panel/VBoxContainer/hard.connect("pressed", self, "_on_difficulty_selected", [52]) # 52 pares para difícil

func _on_difficulty_selected(cards_count):
	# Cambiar nivel utilizando LevelManager
	LevelManager.change_level(cards_count)
	queue_free()  # Cerramos la pantalla de selección de dificultad

func newGame(cards_count):
	# Despausamos el juego y empezamos con la dificultad seleccionada
	get_tree().set_pause(false)
	GameManager.startGame(cards_count)  # Llamamos a GameManager para iniciar el juego con el número de cartas
	queue_free()  # Cerramos la pantalla de selección de dificultad

func win():
	$CenterContainer/Panel/VBoxContainer/TextureRect.set_texture(load("res://Assets-Memorization/ui/complete.jpg"))
