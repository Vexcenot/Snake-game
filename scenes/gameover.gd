extends Control
var skip = false

func _ready() -> void:
	Global.title = true
	if Global.timeUp:
		$timeup.visible = true
	else:
		$gameover.visible = true
	
	await get_tree().create_timer(1).timeout
	skip = true
	
func _input(event):
	if skip:
		get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_audio_stream_player_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
