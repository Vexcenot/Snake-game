extends Node2D

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	if Global.snakePosX >= global_position.x and global_position.x >= Global.spawnCoordx:
		Global.checkPointable = true
		Global.checkPointable2 = true
		Global.spawnCoordx = global_position.x
		Global.spawnCoordy = global_position.y
		print("TURKEY")
		queue_free()
