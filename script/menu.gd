extends Control
var highlight = false

func _process(delta: float) -> void:
	print(Global.demoTimer)
	if Global.demo == false:
		if highlight:
			$"CanvasLayer/VBoxContainer/2 player".grab_focus()
		else:
			$"CanvasLayer/VBoxContainer/1 player".grab_focus()
	if Global.demoTimer > 0:
		Global.demoTimer -= 1 * delta
	if Global.demoTimer <= 0:
		Global.demo = true
	if Global.demo:
		process_mode = Node.PROCESS_MODE_DISABLED
	

func _input(event):
	if Global.demo:
		Global.resetAll()
		get_tree().reload_current_scene()
	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down") or event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
			highlight = not highlight

#sets button 1 focused at start
func _ready() -> void:
	highscorer()
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	if Global.title == false:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		queue_free()
	await get_tree().create_timer(3).timeout
	
	# Disable focus and process input in demo mode
	if Global.demo == true:
		set_process(false)
		set_process_input(false)
		# Remove focus from all buttons
		$"CanvasLayer/VBoxContainer/1 player".focus_mode = Control.FOCUS_NONE
		$"CanvasLayer/VBoxContainer/2 player".focus_mode = Control.FOCUS_NONE

#marks button 2 focused
func _on__player_mouse_entered2() -> void:
	if Global.demo == false:
		highlight = true

#marks button 1 focused
func _on__player_mouse_entered1() -> void:
	if Global.demo == false:
		highlight = false

func _on__player_pressed() -> void:
	if Global.demo == false:
		start()

func _on__player_pressed2() -> void:
	if Global.demo == false:
		start()
		Global.multiplayers = true

func start():
	Global.score = 0
	Global.coin = 0
	get_tree().change_scene_to_file("res://scenes/lvltrans.tscn")

func highscorer():
	$CanvasLayer/VBoxContainer/HBoxContainer/score.text = str(Global.topScore).pad_zeros(6)
