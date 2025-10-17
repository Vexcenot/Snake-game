extends Sprite2D
var shit

func _on_eat_area_body_entered(body: Node2D) -> void:
	if body.name == "snek":
		Sprite2D.visible = false


func _on_flag_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		queue_free()
