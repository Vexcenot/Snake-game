extends Control
var paused = false

func pause():
	get_tree().paused = true
	paused = true
	$AudioStreamPlayer.play()

func unpause():
	get_tree().paused = false

func _input(event):
	if event.is_action_pressed("esc"):
		if paused:
			unpause()
		else:
			pause()
