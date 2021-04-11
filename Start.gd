extends CanvasLayer


func _ready():
	pass


func _on_Start_pressed():
	get_tree().change_scene("res://Game.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_Quit_pressed():
	get_tree().quit()
