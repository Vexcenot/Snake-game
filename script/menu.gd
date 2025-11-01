extends Control
#sets button 1 focused at start
func _ready() -> void:
	if Global.title == false:
		queue_free()
	$"VBoxContainer/1 player".grab_focus()
	await get_tree().create_timer(3).timeout
	
#marks button 2 focused
func _on__player_mouse_entered2() -> void:
	$"VBoxContainer/2 player".grab_focus()

#marks button 1 focused
func _on__player_mouse_entered1() -> void:
	$"VBoxContainer/1 player".grab_focus()
	


func _on__player_pressed() -> void:
	get_tree().change_scene_to_file("res://lvltrans.tscn")


func _on__player_pressed2() -> void:
	get_tree().change_scene_to_file("res://lvltrans.tscn")
	Global.multiplayers = true
