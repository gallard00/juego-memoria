extends TextureButton
class_name Card

# Representa la categoría a la que pertenece la carta (el palo)
var suit

# Contiene el valor de la carta, del 1 al 13
var value

# Textura que muestra la parte de adelante de la carta
var face

# Textura que muestra la parte de atras de la carta
var back

# Se ejecuta cuando la escena está lista
func _ready():
	# Ajusta el tamaño de las cartas para una mejor visualización
	set_h_size_flags(3)
	set_v_size_flags(3)
	set_expand(true)
	set_stretch_mode(TextureButton.STRETCH_KEEP_ASPECT_CENTERED)
	pass

# Inicializa la carta con el palo (suit) y el valor (value)
func _init(s, v):
	suit = s  # Asigna el palo
	value = v  # Asigna el valor
	# Carga la textura correspondiente a la parte de adelante de la carta según su palo y valor
	face = load("res://Assets-Memorization/cards/card-" + str(suit) + "-" + str(value) + ".png")
	# Carga la textura de la parte de atras de la carta desde GameManager
	back = GameManager.cardBack
	# Establece la textura de atras como la textura inicial de la carta
	set_normal_texture(back)
	pass

# Se ejecuta cuando la carta es presionada
func _pressed():
	# Llama a GameManager para que maneje la selección de la carta
	GameManager.chooseCard(self)
	pass

# Voltea la carta, cambiando entre la textura de atras y adelante
func flip():
	# Si la textura actual es la de atras, la cambia a la de adelante
	if get_normal_texture() == back:
		set_normal_texture(face)
	# Si la textura actual es la de adelante, la cambia a la de atras
	else:
		set_normal_texture(back)
	pass
