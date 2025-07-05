extends Node2D
var update = false

func _process(delta: float) -> void:
	if update and Global.shit == false:
		position.x += 2




func _on_move_cam_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		update = true


func _on_move_cam_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		update = false


func _on_castle_detect_area_entered(area: Area2D) -> void:
	if area.name == "entrance":
		Global.shit = true
