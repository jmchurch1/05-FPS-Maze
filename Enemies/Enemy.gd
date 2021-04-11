extends KinematicBody

var health = 200
onready var sound = $Zombie

func _process(_delta):
	if health <= 0:
		queue_free()


func _on_Enemy_body_entered(body):
	if body.name == "Player":
		var _scene = get_tree().change_scene("res://UI/Lose.tscn")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		


func _on_Area_body_entered(body):
	if body.name == "Player":
		if sound != null:
			sound.playing = true
