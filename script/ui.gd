extends Control

#sets button 1 focused at start
func _ready() -> void:
	if Global.title == false:
		queue_free()
	$"VBoxContainer/1 player".grab_focus()
	

#pauses game
func _input(event):
	if event.is_action_pressed("esc") and Global.title == false:
		if Global.paused:
			unpause()
		else:
			pause()

func pause():
	get_tree().paused = true
	Global.paused = true
	$AudioStreamPlayer.play()

func unpause():
	get_tree().paused = false
	Global.paused = false
	$AudioStreamPlayer.play()
	


#marks button 2 focused
func _on__player_mouse_entered() -> void:
	$"VBoxContainer/2 player".grab_focus()

#marks button 1 focused
func _on__player_mouse_entered1() -> void:
	$"VBoxContainer/1 player".grab_focus()
