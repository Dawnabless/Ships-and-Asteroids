extends Node2D
#randomly place asteroids on map every x seconds or when a rock is destroyed
#create a max count of asteroids to exist at any time.
#when rocks get too far from ship, destroy them and remove from rock counter
#when rock is created, add to rock counter
#when rock spawner runs, check if rocks already at max
#if rocks at max, pass, else create new rock and add to counter

#var ship
#var ship_pos

var ship = preload("res://Scenes/ship.tscn")
var rock_path = preload("res://Scenes/rock.tscn")
var fuel_path = preload("res://Scenes/fuel.tscn")
var ship_pos
var rock_count = 0
var rock_max = 50
var removed_rocks = 0
var fuel_count = 0
var fuel_max = 5
var removed_fuel = 0
@onready var rock_true_count = (get_tree().get_nodes_in_group("rock").size() -1) / 2
var removeDistance = 2500
var rocks_on_screen = []


@onready var spawn_timer = $Timer

func make_rock():
#	var randrocksize = randf_range(0.3,2)
	#call this function every x seconds using a timer
	var rock = rock_path.instantiate()
	add_child(rock)
#	rock.scale = Vector2(randrocksize, randrocksize)
	
# Calculate a position around the ship
	var random_angle = randf() * 2.0 * PI
	var spawn_distance = randf_range(1500,2500)  # Adjust this distance as needed
	var offscreen_x = ship.position.x + cos(random_angle) * spawn_distance
	var offscreen_y = ship.position.y + sin(random_angle) * spawn_distance
	
	
	rock.position = Vector2(offscreen_x,offscreen_y)
	rock.add_to_group("rock")
	rock_count += 1
	
	rocks_on_screen.append(rock)
#	print("rock created")
#	print(rock.scale)
	
func make_initial_rocks():
	for x in range(rock_max):
		make_rock()
	rock_count = rock_max


func make_fuel():
	#call this function every x seconds using a timer
	var fuel = fuel_path.instantiate()
	add_child(fuel)

# Calculate a position around the s	hip
	var random_angle = randf() * 2.0 * PI
	var spawn_distance = randf_range(200,400)  # Adjust this distance as needed
	var offscreen_x = ship.position.x + cos(random_angle) * spawn_distance
	var offscreen_y = ship.position.y + sin(random_angle) * spawn_distance


	fuel.position = Vector2(offscreen_x,offscreen_y)
	fuel.add_to_group("fuel")
	fuel_count += 1

#func make_initial_fuel():
#	for x in range(fuel_max):
#		make_fuel()


func _ready():
	ship = $Ship
#	ship_pos = ship.position
	randomize()
#	spawn_timer.start()
	make_initial_rocks()
#	make_initial_fuel()




func _on_button_pressed():
	make_rock()

func _process(delta):
#	ship.position = $Ship.position
#	print("Rock Count:", rock_count)
#	print(get_tree().get_nodes_in_group("rock").size())

	
	
	var objectsInGroup = get_tree().get_nodes_in_group("rock")
	
	var referencePosition = $Ship.global_position
	var objectsToRemove = []
	
	for obj in objectsInGroup:
		var distance = referencePosition.distance_to(obj.global_position)
		if distance > removeDistance:
			objectsToRemove.append(obj)
	
	if objectsInGroup.size() > rock_max:
		for obj_to_remove in objectsToRemove:
			obj_to_remove.queue_free()
	
	
	
	
					# Remove the oldest rock from the list
	if rocks_on_screen.size() > 0:
		print(rocks_on_screen.size())
		for rock in rocks_on_screen:
			if rock and rock.is_inside_tree():
				rock.queue_free()
			rocks_on_screen.clear() #clear queue


func _on_ship_rocky_destroy():
	removed_rocks += 1
	make_fuel()
	print("fuel SPAWNED")



func removeDistantNodes(groupName: String, referenceNode: Node, maxDistance: float):
	var group = get_tree().get_nodes_in_group(groupName)

	for node in group:
		if node != referenceNode:
			var distance = referenceNode.global_position.distance_to(node.global_position)
			if groupName == "rock" and distance > maxDistance:
				node.queue_free()
				removed_rocks += 1
				rock_count -= 1
#			if groupName == "fuel" and distance > maxDistance:
#				node.queue_free()
#				removed_fuel += 1
#				fuel_count -= 1


func spawnReplacementNodes():
	for x in range(removed_rocks):
		make_rock()
	removed_rocks = 0

#func spawnReplacementFuel():
#	for x in range(removed_fuel):
#		make_fuel()
#	removed_fuel = 0



func _on_timer_2_timeout(): #1 second timer
	pass

func _on_timer_timeout(): #3 second timer
	removeDistantNodes("rock", $Ship, 2000)
#	removeDistantNodes("fuel", $Ship, 1000)
	spawnReplacementNodes()
#	spawnReplacementFuel()
