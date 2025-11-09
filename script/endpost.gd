extends Node2D
var shit = false
var point = 100

func _on_winarea_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		$brick/brick.set_collision_layer_value(1, false)
		if Global.direction == "left" and shit == true:
			$AnimationPlayer.play("brick down")
		$"5000".monitoring = false
		$"2000".monitoring = false
		$"800".monitoring = false
		$"400".monitoring = false
		$"100".monitoring = false
		$Label.text = str(point)
		Global.score += point
		$AnimationPlayer.play("flagdown")


func _on_endpost_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		shit = true


func _on_endpost_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		shit = false


func _on_ball_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		$FlagPole.frame = 1


func _on__area_entered100(area: Area2D) -> void:
	point = 100


func _on__area_entered400(area: Area2D) -> void:
	point = 400


func _on__area_entered800(area: Area2D) -> void:
	point = 800


func _on__area_entered2000(area: Area2D) -> void:
	point = 2000


func _on__area_entered5000(area: Area2D) -> void:
	point = 5000
