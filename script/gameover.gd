extends Control
var skip = false

func _ready() -> void:
	skip = true
	Global.world_type = "transition"
	if Global.purgatory:
		$ColorRect2.visible = true
	#Global.world_type = "transition"
	Global.title = true
	if Global.timeUp:
		$timeup.visible = true
	else:
		$gameover.visible = true
	

func _input(event):
	if event.is_action_pressed("ui_accept"):
		next()
		
func next():
	Global.resetAll()
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_audio_stream_player_finished() -> void:
	next()
