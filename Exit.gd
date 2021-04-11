extends Area


func _ready():
	pass


func _on_Exit_body_entered(body):
	if body.name == "Player":
		var _scene = get_tree().change_scene("res://UI/Win.tscn")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
