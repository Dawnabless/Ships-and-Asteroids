extends Node2D

signal fuel_pickup

func _on_area_2d_body_entered(body):
	if body.is_in_group("ship"):
		emit_signal("fuel_pickup")
		queue_free()
