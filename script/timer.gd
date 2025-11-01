extends Control
var low = false

func _process(delta: float) -> void:
	print(Global.timer)
	if Global.timeLive:
		Global.timer -= 1 * delta
	if Global.timer <= 0:
		Global.timeLive = false
		Global.timeUp = true
	if Global.title:
		Global.timer = Global.ogTime

	
