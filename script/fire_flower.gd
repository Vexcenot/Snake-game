extends Node2D


func _on_flower_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		queue_free()
		spawn_score(5)

var point = preload("res://scenes/score.tscn")
func spawn_score(score):
	var spawn2 = score
	var spawn = point.instantiate()
	spawn.value = spawn2
	spawn.global_position = global_position
	Global.hud.add_child(spawn)
