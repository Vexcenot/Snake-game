extends Node2D
@export var x_coords = 0 
@export var y_coords = 0 
@export var x_cam = 0 
@export var y_cam = 0 
@export var teleporterable = false 


func _ready() -> void:
	$pipe_enter.monitorable = teleporterable
	if teleporterable == true:
		print("ass")
		$top_block.set_collision_layer_value(1, false)
		$top_block.set_collision_mask_value(1, false)


func _on_enter_pipe_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and teleporterable == true:
		Global.teleport_x  = x_coords
		Global.teleport_y = y_coords
		Global.cam_telex = x_cam
		Global.cam_teley = y_cam
		print("shit")
		
