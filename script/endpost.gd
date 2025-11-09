extends Node2D
var shit = false


func _on_winarea_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		$brick/brick.set_collision_layer_value(1, false)
		if Global.direction == "left" and shit == true:
			$AnimationPlayer.play("brick down")


func _on_endpost_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		shit = true


func _on_endpost_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		shit = false


func _on_ball_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		$FlagPole.frame = 1
