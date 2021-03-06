extends KinematicBody

onready var Camera = $Pivot/Camera
onready var aimcast = $Pivot/Camera/AimCast
onready var muzzle = $Pivot/donutgun/Muzzle
onready var gun = $Pivot/donutgun
onready var gun_hitbox = $Gun
onready var Footstep = $Footstep
onready var Shot = $Shot
onready var pickup = get_node_or_null("/root/Game/GunPickup")
onready var invisible_gun = get_node_or_null("/root/Game/GunPickup/pedestool/donutgun")
onready var gun_light = get_node_or_null("/root/Game/GunPickup/Light")
onready var bullet = preload("res://bullet/bullet.tscn")


var menu = null
var gravity = -30
var max_speed = 6
var jump_speed = 10
var mouse_sensitivity = 0.002
var mouse_range = 1.2
var damage = 100

var velocity = Vector3()
var jump  = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Shot.CONNECT_ONESHOT

func get_input():
	var input_dir = Vector3()
	if Input.is_action_just_pressed("exit"):
		if menu == null:
			menu = get_node_or_null("UI/InputRemapMenu")
		if menu != null:
			if not menu.visible:
				get_tree().paused = true
				menu.show()
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				get_tree().paused = false
				Global.save_input()
				menu.hide()
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	if Input.is_action_just_pressed("jump"):
		jump = true
	if Input.is_action_just_pressed("shoot") and not get_tree().paused:
		shoot()
	if Input.is_action_just_pressed("interact") and not get_tree().paused:
		#I am a genius lol
		#I put way to much random stuff in the player script
		if pickup != null:
			if pickup.in_box:
				invisible_gun.hide()
				gun.show()
				gun_hitbox.disabled = false
				gun_light.light_energy = 0
	if Input.is_action_pressed("forward") and not get_tree().paused:
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("back") and not get_tree().paused:
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left") and not get_tree().paused:
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("right") and not get_tree().paused:
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
	
	if velocity.x != 0 or velocity.z != 0  and is_on_floor():
		if !Footstep.playing:
			Footstep.play()
	elif Footstep.playing:
		Footstep.stop()
	
	
func shoot():
	if aimcast.is_colliding():
		Shot.play()
		var b = bullet.instance()
		muzzle.add_child(b)
		b.look_at(aimcast.get_collision_point(), Vector3.UP)
		b.shoot = true


