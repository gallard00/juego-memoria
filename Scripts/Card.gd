extends TextureButton
class_name Card

#Representa la categoria que pertenece la carta
var suit

#Contiene el valor de las cartas desde 1 hasta 13
var value

#Contiene la textura y mostrara la parte frontal de la carta
var face

#Contiene la textura que mostrara la parte trasera de la carta
var back


func _ready():
#Definimos el alto y ancho de las cartas para que se ajusten para una mejor visualizacion
	set_h_size_flags(3)
	set_v_size_flags(3)
	set_expand(true)
	set_stretch_mode(TextureButton.STRETCH_KEEP_ASPECT_CENTERED)
	pass

func _init(var s, var v):
	suit = s
	value = v
	face = load("res://Assets-Memorization/cards/card-"+str(suit)+"-"+str(value)+".png")
	back = GameManager.cardBack
	set_normal_texture(back)
	pass

func _pressed():
	GameManager.chooseCard(self)
	pass
	
#Verificamos que textura tiene la carta accedemos a la textura normal del boton usando el metodo get_normal_texture
#si corresponde a back, cambiamos de textura a face sino se elige la textura back
func flip():
	if get_normal_texture() == back:
		set_normal_texture(face)
	else:
		set_normal_texture(back)
	pass 
