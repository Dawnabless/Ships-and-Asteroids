extends Node2D


signal rock_hit
signal rock_destroy

var speed = 300

func _ready():
	remove_bullet()

func _physics_process(delta):
	position -= transform.y * speed * delta

func _on_area_2d_body_entered(body):
	
	if body.is_in_group("rock"):
		emit_signal("rock_hit")
		queue_free()
		body.scale /= 2
		if body.scale.x < 0.2:
			body.queue_free()
			print("destroyed")
			emit_signal("rock_destroy")
		print("HIT")
	if body.is_in_group("ship"):
		pass

func remove_bullet():
	await get_tree().create_timer(10.0).timeout # waits for 1 second
	queue_free()
