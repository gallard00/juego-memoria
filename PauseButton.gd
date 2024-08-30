extends TextureButton


func _ready():
	pass
#Si no esta pausado lo pausamos sino despausamos, y cambiamos los elementos por play y pause dependiendo el estado
func _pressed():
	if !get_tree().is_paused():
		get_tree().set_pause(true)
		set_normal_texture(load("res://Assets-Memorization/ui/play.png"))
	else:
		get_tree().set_pause(false)
		set_normal_texture(load("res://Assets-Memorization/ui/pause.png"))
	pass
