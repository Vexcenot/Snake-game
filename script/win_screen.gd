extends Control
var skip = false

func _ready() -> void:
	skip = true
	if Global.multiplayers:
		$"2p msg".visible = true
	else:
		$"1p msg".visible = true

func _input(event):
	if event.is_action_pressed("ui_accept") and skip:
		Global.title = true
		get_tree().change_scene_to_file("res://scenes/main.tscn")
