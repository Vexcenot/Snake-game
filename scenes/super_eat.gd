extends Node2D


func _on_super_eat_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		#await get_tree().process_frame
		queue_free()
