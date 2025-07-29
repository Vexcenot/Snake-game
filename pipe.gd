extends Node2D
@export var x_snek = 0 
@export var y_snek = 0 
@export var x_cam = 0 
@export var y_cam = 0 
@export var teleporterable = false 


func _ready() -> void:
	$pipe_enter.monitorable = teleporterable
	if teleporterable == true:
		print("ass")
		$top_block.queue_free()


func _on_enter_pipe_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and teleporterable == true:
		$PowerDown.play()
		Global.teleport_x  = x_snek
		Global.teleport_y = y_snek
		Global.cam_telex = x_cam
		Global.cam_teley = y_cam
		await get_tree().create_timer(1.2).timeout
		Global.teleport_all = true
		
