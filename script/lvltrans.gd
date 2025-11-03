extends Control


func _ready() -> void:
	#Global.world_type = "transition"
	Global.timeLive = false
	await get_tree().create_timer(2.3).timeout
	Global.title = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")
