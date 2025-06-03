extends Node2D
var move_toggle = false

func _process(delta: float) -> void:
	move_camera()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		move_toggle = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		move_toggle = false


func move_camera():
	if move_toggle:
		global_position.x += 1
