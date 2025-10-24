extends Node
var timer = 400


func _ready() -> void:
	Global.world_type = "overworld"
	Global.loadedWorld = "res://scenes/main.tscn"

func _process(delta: float) -> void:
	timer -= 1 * delta
	if timer <= 0:
		pass # kill the snake	
