extends KinematicBody

onready var Camera = $Pivot/Camera
onready var muzzle = get_node("Player/Pivot/donutgun/Muzzle")
onready var donut_scene = preload("res://donutgun.tscn")


var gravity = -30
var max_speed = 8
var jump_speed = 10
var mouse_sensitivity = 0.002
var mouse_range = 1.2
var ammo = 10

var velocity = Vector3()
var jump  = false

func get_input():
	var input_dir = Vector3()
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("jump"):
		jump = true
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_pressed("forward"):
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -mouse_range, mouse_range)

func _physics_process(delta):
	velocity.y += gravity * delta
	var desired_velocity = get_input() * max_speed
	
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	if jump and is_on_floor():
		velocity.y = jump_speed
		jump = false

func shoot():
	var donut = donut_scene.instance()
	get_node("/root/Game").add_child(donut)
	
	donut.global_transform = muzzle.global_transform
	donut.scale = Vector3.ONE
	ammo -= 1
