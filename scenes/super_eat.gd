extends Node2D

var point = preload("res://scenes/score.tscn")
func spawn_score(score):
	var spawn2 = score
	var spawn = point.instantiate()
	spawn.value = spawn2
	spawn.global_position = global_position
	Global.hud.add_child(spawn)

func _on_super_eat_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		spawn_score(5)
		queue_free()
