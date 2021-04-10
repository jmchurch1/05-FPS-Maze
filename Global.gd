extends Node

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

