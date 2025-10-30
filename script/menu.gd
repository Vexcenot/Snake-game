extends Control

#sets button 1 focused at start
func _ready() -> void:
	if Global.title == false:
		queue_free()
	$"VBoxContainer/1 player".grab_focus()
	

	


#marks button 2 focused
func _on__player_mouse_entered() -> void:
	$"VBoxContainer/2 player".grab_focus()

#marks button 1 focused
func _on__player_mouse_entered1() -> void:
	$"VBoxContainer/1 player".grab_focus()
