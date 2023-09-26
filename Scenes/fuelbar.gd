extends Node2D
signal no_fuel
signal has_fuel

@onready var fuel = $TextureProgressBar

func _on_fuel_fuel_pickup():
	fuel.value += 50
	print("fuel +50")
	emit_signal("has_fuel")

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		fuel.value -= 0.2
		check_fuel()
	if Input.is_action_pressed("ui_down"):
		fuel.value -= 0.2
		check_fuel()
	if Input.is_action_just_pressed("ui_accept"):
		fuel.value -= 1
		check_fuel()
	
#	if check_fuel() == true :
#		print("NO FUEL")

func check_fuel():
	if fuel.value <=0:
		emit_signal("no_fuel")
		return true


func _on_ship_add_fuel():
	fuel.value += 50
	emit_signal("has_fuel")
