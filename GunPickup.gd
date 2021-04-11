extends Area

onready var gun = $pedestool/donutgun
var in_box = false

func _ready():
	pass


func _on_GunPickup_body_entered(body):
	if body.name == "Player":
		var player = get_node_or_null("/root/Game/Player")
		if player != null:
			in_box = true
		
		
	
