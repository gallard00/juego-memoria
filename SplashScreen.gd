extends Control

#var playButton

func _ready():
	#get_tree().set_pause(true)
	#playButton = $CenterContainer/Panel/VBoxContainer/Button
	#playButton.connect("pressed", self, "newGame")
	get_tree().set_pause(true)
	
	# Conectamos cada botón a la función newGame con la dificultad como argumento
	$CenterContainer/Panel/VBoxContainer/easy.connect("pressed", self, "_on_difficulty_selected", [12])  # 12 pares
	$CenterContainer/Panel/VBoxContainer/normal.connect("pressed", self, "_on_difficulty_selected", [26]) # 26 pares
	$CenterContainer/Panel/VBoxContainer/hard.connect("pressed", self, "_on_difficulty_selected", [52]) # 52 pares (modo completo)

	pass

func _on_difficulty_selected(cards_count):
	newGame(cards_count)

func newGame(cards_count):
	get_tree().set_pause(false)
	GameManager.startGame(cards_count)
	queue_free()
	pass

#func newGame():
	#get_tree().set_pause(false)
	#GameManager.resetGame()
	#queue_free()
	#pass
#func start_game():
	#get_tree().set_pause(false)
	#GameManager.resetGame()
	#queue_free()
#func win():
	#$CenterContainer/Panel/VBoxContainer/TextureRect.set_texture(load("res://Assets-Memorization/ui/complete.jpg"))
	#pass
