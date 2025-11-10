extends Control
#sets button 1 focused at start
func _ready() -> void:
	highscorer()
	if Global.title == false:
		queue_free()
	$"CanvasLayer/VBoxContainer/1 player".grab_focus()
	await get_tree().create_timer(3).timeout

#marks button 2 focused
func _on__player_mouse_entered2() -> void:
	$"CanvasLayer/VBoxContainer/2 player".grab_focus()

#marks button 1 focused
func _on__player_mouse_entered1() -> void:
	$"CanvasLayer/VBoxContainer/1 player".grab_focus()

func _on__player_pressed() -> void:
	start()

func _on__player_pressed2() -> void:
	start()
	Global.multiplayers = true

func start():
	Global.score = 0
	Global.coin = 0
	get_tree().change_scene_to_file("res://scenes/lvltrans.tscn")
	

func highscorer():
	$CanvasLayer/VBoxContainer/HBoxContainer/score.text = str(Global.topScore).pad_zeros(6)
