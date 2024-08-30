extends Control

var playButton

func _ready():
	get_tree().set_pause(true)
	
	playButton = $CenterContainer/Panel/VBoxContainer/Button
	
	playButton.connect("pressed", self, "newGame")
	pass

func newGame():
	get_tree().set_pause(false)
	GameManager.resetGame()
	queue_free()
	pass

func win():
	$CenterContainer/Panel/VBoxContainer/TextureRect.set_texture(load("res://Assets-Memorization/ui/complete.jpg"))
	pass
