extends Node2D
var shit = false
var point = 0
var live = true

func _on_winarea_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and live:
		live = false
		Global.playMusic = true
		Global.music = "flag"
		$brick/brick.set_collision_layer_value(1, false)
		if Global.direction == "left" and shit == true:
			$AnimationPlayer.play("brick down")
		labelScore()


func _on_endpost_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		shit = true


func _on_endpost_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		shit = false


func _on_ball_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		$FlagPole.frame = 1


func _on__area_entered5k(area: Area2D) -> void:
	point = 5000


func _on__area_entered2k(area: Area2D) -> void:
	point = 2000


func _on__area_entered8c(area: Area2D) -> void:
	point = 800


func _on__area_entered4c(area: Area2D) -> void:
	point = 400


func _on__area_entered1c(area: Area2D) -> void:
	point = 100
	
func labelScore():
	$AnimationPlayer.play("flagdown")
	$Label.text = str(point)
	Global.score += point
