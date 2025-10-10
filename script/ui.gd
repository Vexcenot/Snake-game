extends Control

func pause():
	get_tree().paused = true
	Global.paused = true
	$AudioStreamPlayer.play()

func unpause():
	get_tree().paused = false
	Global.paused = false
	$AudioStreamPlayer.play()

func _input(event):
	if event.is_action_pressed("esc"):
		if Global.paused:
			unpause()
		else:
			pause()
