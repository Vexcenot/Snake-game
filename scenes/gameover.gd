extends Control
var skip = false

func _ready() -> void:
	#Global.world_type = "transition"
	if Global.purgatory:
		$ColorRect2.visible = true
		$AudioStreamPlayer.volume_db = -80
	else:
		Global.title = true
		if Global.timeUp:
			$timeup.visible = true
		else:
			$gameover.visible = true
		
		#await get_tree().create_timer(1).timeout
		skip = true
	
func _input(event):
	if skip:
		end()

func _on_audio_stream_player_finished() -> void:
	end()
	
func end():
	Global.resetAll()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
