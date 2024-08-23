extends Node

#Definimos una variable que contendra la referencia al nodo raiz que contiene la escena Game
onready var Game = get_node('/root/Game/')

#Definimos una variable de tipo arreglo para contener todas las cartas
var deck = Array()

#Definimos la textura de la parte tracera de la carta
var cardBack = preload("res://Assets-Memorization/cards/cardBack_blue2.png")

func _ready():
	fillDeck()
	dealDeck()
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
	var suit = 1
	var value = 1
	
	while suit < 5:
		value = 1
		while value < 14:
			deck.append(Card.new(suit, value))
			value = value + 1
		suit += 1
	pass
#Se encarga de agregar las cartas dentro del grid
func dealDeck():
	#Game.get_node('Grid').add_child(deck[0])
	#Por medio del ciclo for vamos a estar recorriendo todo el arreglo incluyendo las 52 cartas
	#Por ese motivo usamos deck.size() para considerar todo el contenido del arreglo 
	for i in deck.size():
		Game.get_node('Grid').add_child(deck[i])
	pass
