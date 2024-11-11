extends Node

# Definimos una variable que contiene la referencia al nodo raíz que contiene la escena Game
onready var Game = get_node('/root/Game/')

# Definimos la textura de la parte de atras de la carta
var cardBack = preload("res://Assets-Memorization/cards/cardBack_blue2.png")

# Arreglo que contendrá todas las cartas
var deck = Array()

# Variables para almacenar las primeras dos cartas seleccionadas por el jugador
var card1
var card2

# Timers para controlar el juego
var matchTimer = Timer.new()
var flipTimer = Timer.new()
var secondsTimer = Timer.new()

# Variables para manejar la puntuación, los segundos transcurridos y los movimientos del jugador
var score = 0
var seconds = 0
var moves = 0

# Referencias a las etiquetas de HUD
var scoreLabel
var timerLabel
var movesLabel

# Meta de cartas a encontrar, según el modo de juego (26 pares para modo difícil)
var goal_hard
var goal_normal
var goal_easy

# Pantalla de victoria
var splashScreen = preload('res://Scenes/SplashScreen.tscn')

var cards_count = 0  # Cantidad de cartas para la partida

# Botón de reinicio
var resetButton

# Sonidos del juego
var sound_flipped_card = preload("res://Assets-Memorization/sounds/Flipped_Card.wav")
var sound_hidden_card = preload("res://Assets-Memorization/sounds/Hidden_Card.wav")
var sound_score_increase = preload("res://Assets-Memorization/sounds/Score_Increase.wav")

# Reproductor de sonido
var audiosp = AudioStreamPlayer.new()

# Función que se llama cuando la escena está lista
func _ready():
	randomize()
	setupTimers()
	setuoHUD()

	# Instanciamos la pantalla de splash y el reproductor de audio
	var splashS = splashScreen.instance()
	Game.add_child(splashS)
	Game.add_child(audiosp)

# Inicia el juego con el número de cartas dependiendo de la dificultad seleccionada
func startGame(selected_cards_count):
	# Asignamos el número de cartas seleccionadas a la variable global cards_count
	cards_count = selected_cards_count

	# Dependiendo del número de cartas seleccionadas, asignamos la meta correspondiente al nivel de dificultad
	if cards_count == 12:  # Nivel fácil
		goal_easy = 6  # 6 pares (12 cartas)
	elif cards_count == 24:  # Nivel normal
		goal_normal = 12  # 13 pares (26 cartas)
	elif cards_count == 52:  # Nivel difícil
		goal_hard = 26  # 26 pares (52 cartas)
	
	resetGame()  # Reiniciamos el estado del juego



# Configuración del HUD (puntaje, tiempo, movimientos y botón de reinicio)
func setuoHUD():
	scoreLabel = Game.get_node('HUD/Panel/Sections/SectionScore/Score')
	timerLabel = Game.get_node('HUD/Panel/Sections/SectionTimer/Seconds')
	movesLabel = Game.get_node('HUD/Panel/Sections/SectionMoves/Moves')
	scoreLabel.text = str(score)
	timerLabel.text = str(seconds)
	movesLabel.text = str(moves)

	resetButton = Game.get_node('HUD/Panel/Sections/SectionButtons/ResetButton')
	resetButton.connect("pressed", self, "resetGame")

# Configura los timers y conecta sus señales
func setupTimers():
	flipTimer.connect("timeout", self, "turnOverCards")
	flipTimer.set_one_shot(true)
	add_child(flipTimer)

	matchTimer.connect("timeout", self, "matchCardsAndScore")
	matchTimer.set_one_shot(true)
	add_child(matchTimer)

	secondsTimer.connect("timeout", self, "countSeconds")
	add_child(secondsTimer)
	secondsTimer.start()

# Llena el mazo de cartas según la dificultad seleccionada
func fillDeck():
	deck.clear()  # Limpiamos el mazo
	var suits = 4  # Cuatro palos (ej: corazones, diamantes, tréboles y picas)

	# Calculamos cuántos valores por palo debemos tener, dependiendo de la cantidad total de cartas
	var values_per_suit = cards_count / suits  # Se divide la cantidad de cartas por los palos

	# Bucle para generar las cartas según la cantidad de palos y valores
	for s in range(1, suits + 1):
		for v in range(1, int(values_per_suit) + 1):
			# Creamos una nueva carta y la añadimos al mazo
			deck.append(Card.new(s, v))


# Desordenamos el mazo y lo agregamos al nodo Grid
func dealDeck():
	deck.shuffle()  # Desordenamos las cartas
	for i in range(deck.size()):
		Game.get_node('Grid').add_child(deck[i])  # Agregamos las cartas al Grid

# Manejamos la selección de cartas por parte del jugador
func chooseCard(var c):
	if card1 == null:
		card1 = c
		card1.flip()
		audiosp.stream = sound_flipped_card
		audiosp.volume_db = -5
		audiosp.play()
		card1.set_disabled(true)
	elif card2 == null:
		card2 = c
		card2.flip()
		audiosp.play()
		card2.set_disabled(true)
		moves += 1
		movesLabel.text = str(moves)
		checkCards()

# Verificamos si las cartas coinciden en valor
func checkCards():
	if card1.value == card2.value:
		matchTimer.start(1)  # Temporizador para procesar la coincidencia
	else:
		flipTimer.start(1)  # Temporizador para voltear las cartas

# Incrementamos el puntaje y deshabilitamos las cartas coincidentes
func matchCardsAndScore():
	score += 1
	scoreLabel.text = str(score)
	card1.set_modulate(Color(0.6, 0.6, 0.6, 0.5))  # Cambiamos el color de las cartas acertadas
	card2.set_modulate(Color(0.6, 0.6, 0.6, 0.5))
	card1 = null
	card2 = null

	audiosp.stream = sound_score_increase
	audiosp.play()

	# Si el jugador encuentra todos los pares, mostramos la pantalla de victoria
	if (score == goal_easy and cards_count == 12) or (score == goal_normal and cards_count == 24) or (score == goal_hard and cards_count == 52):
		var winScreen = splashScreen.instance()
		Game.add_child(winScreen)
		winScreen.win()

# Volteamos las cartas si no coincidieron
func turnOverCards():
	card1.flip()
	card2.flip()
	card1.set_disabled(false)
	card2.set_disabled(false)
	card1 = null
	card2 = null

	audiosp.stream = sound_hidden_card
	audiosp.play()

# Contador de segundos
func countSeconds():
	seconds += 1
	timerLabel.text = str(seconds)

#Gestiona los estados del juego sin reiniciarlo cuando se desea seguir en el mismo nivel.
func resumeGame():
	get_tree().set_pause(false)

# Reinicia el juego para el cambio de nivel
func resetGame():
	for c in range(deck.size()):
		deck[c].queue_free()  # Libera todas las cartas
	deck.clear()
	score = 0
	seconds = 0
	moves = 0
	scoreLabel.text = str(score)
	timerLabel.text = str(seconds)
	movesLabel.text = str(moves)
	fillDeck()  # Llenamos de nuevo el mazo
	dealDeck()  # Distribuimos las cartas
