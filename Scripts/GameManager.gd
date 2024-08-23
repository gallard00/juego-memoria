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

#Variable encargadad de la puntuacion
var score = 0

func _ready():
	fillDeck()
	dealDeck()
	setupTimers()
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
		card1.set_disabled(true)
	elif card2 == null:
		card2 = c
		card2.flip()
		card2.set_disabled(true)
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
	card1.set_modulate(Color(0.6,0.6,0.6,0.5))
	card2.set_modulate(Color(0.6,0.6,0.6,0.5))
	card1 = null
	card2 = null
	pass

func turnOverCards():
	card1.flip()
	card2.flip()
	card1.set_disabled(false)
	card2.set_disabled(false)
	card1 = null
	card2 = null
	pass


