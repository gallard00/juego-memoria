extends Node


# Almacena el nivel actual para verificar si el jugador está en el mismo nivel
var current_level = null

# Cambia de nivel solo si es necesario
func change_level(selected_level):
	if current_level != selected_level:
		current_level = selected_level
		GameManager.resetGame()  # Reiniciamos el juego para empezar con el nuevo nivel
		GameManager.startGame(current_level)
	else:
		GameManager.resumeGame()  # Simplemente reanuda si el nivel es el mismo
