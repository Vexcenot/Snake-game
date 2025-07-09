extends Sprite2D
var shit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_eat_area_body_entered(body: Node2D) -> void:
	if body.name == "snek":
		Sprite2D.visible = false


func _on_eat_area_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		#set_power("big")
		queue_free()
