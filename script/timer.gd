extends Control
var low = false

func _process(delta: float) -> void:
	print(Global.timer)
	if Global.timeLive:
		Global.timer -= 1 * delta
	if Global.timer <= 0:
		Global.timeLive = false
		await get_tree().create_timer(1).timeout
		Global.timeUp = true
	if Global.title:
		Global.timer = Global.ogTime
		
	
	
	#if Global.timer <= 100 and low == false:
		#low = true
		#$AudioStreamPlayer.play()
		#Global.lowTimer = true
	
