extends Sprite2D
var underground_sprite = load("res://sprite/dark stuff.png")
var overworld_sprite = load("res://sprite/all the small blocks together.png")


func _process(delta: float) -> void:
	if Global.world_type == "underground":
		$".".texture = underground_sprite
