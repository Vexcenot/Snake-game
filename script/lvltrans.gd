extends Control
var skip = false

func _ready() -> void:
	if Global.multiplayers:
		$"2p".visible = true
	else:
		$"1p".visible = true
	Global.world_type = "transition"
	Global.timeLive = false
	await get_tree().create_timer(2.3).timeout
	switch()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		switch()


func switch():
	Global.title = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")
