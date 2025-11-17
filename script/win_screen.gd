extends Control
var skip = false



func _ready() -> void:
	Global.timer = Global.ogTime
	Global.world_type = "transition"
	skip = true
	if Global.multiplayers:
		print("SHIT")
		$"2p msg".visible = true
	else:
		print("fuck")
		$"1p msg".visible = true
	await get_tree().create_timer(20).timeout
	next()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		next()

func next():
	Global.title = true
	Global.entranceStopper = false
	Global.winning = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	Global.resetAll()
