extends Control
var skip = false

func _ready() -> void:
	skip = true
	Global.world_type = "transition"
	if Global.purgatory:
		$ColorRect2.visible = true
	#Global.world_type = "transition"
	Global.title = true
	if Global.timeUp:
		$timeup.visible = true
	else:
		$gameover.visible = true
	await get_tree().create_timer(5).timeout
	next()
	

#func _input(event):
	#if skip:
		#next()
		
func next():
	Global.resetAll()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
