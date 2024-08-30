extends Node

#Definimos una variable que contendra la referencia al nodo raiz que contiene la escena Game
onready var Game = get_node('/root/Game/')

#Definimos la textura de la parte tracera de la carta
var cardBack = preload("res://Assets-Memorization/cards/cardBack_blue2.png")

#Definimos una variable de tipo arreglo para contener todas las cartas
var deck = Array()

#es para saber las primeras dos cartas que el jugador preciono
var card1
var card2

var matchTimer = Timer.new()
var flipTimer = Timer.new()
var secondsTimer = Timer.new()

#Variable encargadad de la puntuacion
var score = 0
#Variable encargada de los segundos transcurridos en el juego
var seconds = 0
#Variable encargadad de contabilizar los movimientos del jugador
var moves = 0

var scoreLabel
var timerLabel
var movesLabel

var goal = 26 # cambiar a 26

var splashScreen = preload('res://Scenes/SplashScreen.tscn')

var resetButton

var sound_flipped_card = preload("res://Assets-Memorization/sounds/Flipped_Card.wav")
var sound_hidden_card = preload("res://Assets-Memorization/sounds/Hidden_Card.wav")
var sound_score_increase = preload("res://Assets-Memorization/sounds/Score_Increase.wav")

var audiosp = AudioStreamPlayer.new()

func _ready():
	randomize()
	fillDeck()
	dealDeck()
	setupTimers()
	setuoHUD()
	
	var splashS = splashScreen.instance()
	Game.add_child(splashS)
	Game.add_child(audiosp)
	pass

func setuoHUD():
	scoreLabel = Game.get_node('HUD/Panel/Sections/SectionScore/Score')
	timerLabel = Game.get_node('HUD/Panel/Sections/SectionTimer/Seconds')
	movesLabel = Game.get_node('HUD/Panel/Sections/SectionMoves/Moves')
	scoreLabel.text = str(score)
	timerLabel.text = str(seconds)
	movesLabel.text = str(moves)
	
	resetButton = Game.get_node('HUD/Panel/Sections/SectionButtons/ResetButton')
	resetButton.connect("pressed", self, "resetGame")
	pass

#Cuando las cartas no tienen el mismo numero conectamos la señal
#Se activa el one shot para que el timer sea ejecutado una sola vez
#Despues el timer se añade como hijo
#Mismos pasos para el otro timer
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
	pass
#Definimos una funcion que se encarga de crear el mazo
func fillDeck():
	#deck.append(Card.new(1,1))
	#Iniciamos las variables Suit y Value en 1 ya que existen 4 palos en que se dividen las cartas en una baraja,
	#si la variable suit es menor que 5 significa que quedan cartas por definir cada vez que iniciamos el agregado de un nuevo palo
	#inicializamos la variable value que representa al valor de la carta empezando desde su valor inicial, es decir 1
	#en cada palo existen 13 cartas por lo que por medio de otro while verficamos mientras value sea menor a 14 significa que tenemos que seguir agregando cartas hasta llegar al valor de 13
	#mediante deck.append vamos a estar agregando cartas dentro del array cuando agregamos una carta le aumentamos el valor de la variable value para asi estar agregando todas las demas cartas pertenecientes al mismo palo
	#cuando terminamos salimos del bucle while, incrementamos el valor de suite para pasar al siguiente palo para asi volver a repetir esta secuencia de codigo
	var s = 1
	var v = 1
	
	while s < 5:
		v = 1
		while v < 14:
			deck.append(Card.new(s, v))
			v = v + 1
		s += 1
	pass
#Se encarga de agregar las cartas dentro del grid
func dealDeck():
	deck.shuffle() #shuffle() sirve para desordenar el arreglo de cartas
	#Game.get_node('Grid').add_child(deck[0])
	#Por medio del ciclo for vamos a estar recorriendo todo el arreglo incluyendo las 52 cartas
	#Por ese motivo usamos deck.size() para considerar todo el contenido del arreglo 
	for i in deck.size():
		Game.get_node('Grid').add_child(deck[i])
	pass


#si nuestra variable card1 esta vacia si es cierto el jugador voltea su primera carta
#hacemos que la variable card1 obtenga la referencia de la carta 1 que el jugador preciono
#hacemos el volteo de la carta llamando a la funion flip()
#finalmente llamamos a set_disabled(true) para que la carta cuando sea volteada no pueda volver a voltearse
#con el elif seguimos con la misma logica
func chooseCard(var c):
	if card1 == null:
		card1 = c
		card1.flip()
		audiosp.stream = sound_flipped_card #Definimos el audio correspondiente
		audiosp.volume_db = -5 #Bajamos el volumen
		audiosp.play() #Reproducimos el audio
		card1.set_disabled(true)
	elif card2 == null:
		card2 = c
		card2.flip()
		audiosp.play()
		card2.set_disabled(true)
		moves += 1
		movesLabel.text = str(moves)
		checkCards()
	pass


#Comprobamos si las cartas tienen el mismo numero accediendo a su variable value
#Si es cierto a cada una de las cartas le aplico un cambio de color para diferenciar las cartas que ya acerto
#Despues hacemos que las variables card1 y 2 queden receteadas para que el jugador pueda volver a legir cartas
#si es falso hacemos que las cartas vuelvan a darse vuelta con la funcion flip()
#Llamamos a la funcion set_disabled a false para desactivar la desahbilitacion para que puedan volver a ser elegidas
#las variables vuelven a su estado inicial para que el jugador vuelva a elegir dos cartas
func checkCards():
	if card1.value == card2.value:
		matchTimer.start(1)
	else:
		flipTimer.start(1)
	pass

func matchCardsAndScore():
	score += 1
	scoreLabel.text = str(score)
	card1.set_modulate(Color(0.6,0.6,0.6,0.5))
	card2.set_modulate(Color(0.6,0.6,0.6,0.5))
	card1 = null
	card2 = null
	
	audiosp.stream = sound_score_increase
	audiosp.play()
	
	if score == goal:
		var winScreen = splashScreen.instance()
		Game.add_child(winScreen)
		winScreen.win()
	pass

func turnOverCards():
	card1.flip()
	card2.flip()
	card1.set_disabled(false)
	card2.set_disabled(false)
	card1 = null
	card2 = null
	
	audiosp.stream = sound_hidden_card
	audiosp.play()
	pass

func countSeconds():
	seconds += 1
	timerLabel.text = str(seconds)
	pass

func resetGame():
	for c in range(deck.size()): #Recorremos el arreglo
		deck[c].queue_free() #Liberamos cada carta del arreglo
	deck.clear()
	score = 0
	seconds = 0
	moves = 0
	scoreLabel.text = str(score)
	timerLabel.text = str(seconds)
	movesLabel.text = str(moves)
	fillDeck()
	dealDeck()
	pass

