extends Node2D


func _on_flower_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		queue_free()
