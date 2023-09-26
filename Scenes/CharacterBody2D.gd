extends CharacterBody2D

signal rocky_hit
signal rocky_destroy
signal add_fuel

@export var Bullet = preload("res://Scenes/bullet.tscn")
@export var Fuel = preload("res://Scenes/fuel.tscn")

@export var speed = 10
@export var topspeed = 400
@export var rotation_speed = 3
var has_fuel = true


var rotation_direction = 0

func shoot():
	if has_fuel == true:
		var b = Bullet.instantiate()
		owner.add_child(b)
		b.transform = $Gun.global_transform
		b.connect("rock_hit", _on_bullet_hit)
		b.connect("rock_destroy", _on_rock_destroy)



func get_input():
	rotation_direction = Input.get_axis("ui_left", "ui_right")
	if has_fuel == true:
		velocity -= transform.y * Input.get_axis("ui_down", "ui_up") * speed
	
	if velocity.length() > topspeed:
		velocity = velocity.normalized() * topspeed


func _on_bullet_hit():
	emit_signal("rocky_hit")
#	print("we did it")

func _on_rock_destroy():
	emit_signal("rocky_destroy")
#	print("kaboom")

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_accept"):
		shoot()
		


func _on_fuelbar_no_fuel():
	has_fuel = false


func _on_fuelbar_has_fuel():
	has_fuel = true


func _on_area_2d_area_entered(area):
	var fuelbarvalue = 0
	if area.is_in_group("fuel"):
		emit_signal("add_fuel")
