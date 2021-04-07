extends Area

var speed = 30.0
var damage = 1


func _physics_process(delta):
	translation += Global.transform.basis.z * speed * delta

func _on_donut_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
