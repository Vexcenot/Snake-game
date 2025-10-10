extends Node2D

func pausing():
	if Global.paused == true:
		set_process_mode(PROCESS_MODE_INHERIT)

	else:
		set_process_mode(PROCESS_MODE_ALWAYS)
		
func _process(delta: float) -> void:
	pausing()
