extends Node2D
var update = false

func _process(delta: float) -> void:
	teleport()
	camera_updater()
		
func _physics_process(delta: float) -> void:
	if update == true and Global.entranceStopper == false:
		position.x += 16

func teleport():
	if Global.teleport_all:
		Global.teleport_all = false
		Global.teleport_all2 = true
		position.x = Global.cam_telex
		position.y = Global.cam_teley
		
func camera_updater():
	Global.camera_limit = position.x

func _on_move_cam_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		update = true


func _on_move_cam_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		update = false


func _on_castle_detect_area_entered(area: Area2D) -> void:
	if area.name == "entrance":
		Global.entranceStopper = true
