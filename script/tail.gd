extends Node2D

var pole_touched = false




#func _on_tail_area_area_entered(area: Area2D) -> void:
	#if area.name == "winarea":
		#$Sprite2D.set_layer_z_index = 1
