extends Node2D
var move_toggle = false

func _ready() -> void:
	if Global.checkPointable:
		position.x = Global.spawnCoordx - 56
	if Global.teleport_all:
		#Global.teleport_all = false
		position.x = Global.cam_telex
		position.y = Global.cam_teley
		#Global.teleport_all2 = true

func _process(delta: float) -> void:
	move_camera(delta)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		move_toggle = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		move_toggle = false


func move_camera(delta):
	if move_toggle:
		global_position.x += 1.0*delta
