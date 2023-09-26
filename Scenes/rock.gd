extends Node2D

func _ready():
	
	
	
	#spawn in with random size
	randomize()
	var randsize = randf_range(0.3,2)
	$RigidBody2D.scale = Vector2(randsize,randsize)
	$RigidBody2D/Sprite2D.scale = Vector2(randsize,randsize)
#	print(scale)
	pass

func _process(delta):
#	$RigidBody2D.scale = scale
	pass
