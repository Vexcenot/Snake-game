extends Node2D
@export var x_snek = 0 
@export var y_snek = 0 
@export var x_cam = 0 
@export var y_cam = 0 
@export var teleporterable = false 
@export var gotoPipe = false 
@export_file var world
@export_file var ID : String
@export var TargetID : String
@export_enum("1", "2")
var pipe_type: int
var underground_sprite = load("res://sprite/pipe dark.png")
var overworld_sprite = load("res://sprite/pipe.png")


func _ready() -> void:
	if pipe_type == 1:
		$Pipe.frame = 1
	if Global.targetting_pipe == ID:
		push_teleport()
		set_direction()
	$pipe_enter.monitorable = teleporterable
	if teleporterable == true:
		print("ass")
		$top_block.set_collision_layer_value(1, false)
		$top_block.set_collision_layer_value(2, false)

func _process(delta: float) -> void:
	if Global.world_type == "underground":
		$Pipe.texture = underground_sprite



func push_teleport():
	Global.teleport_x  = x_snek
	Global.teleport_y = y_snek
	Global.cam_telex = x_cam
	Global.cam_teley = y_cam



#theory that snake should be instated through spawn point instead of base world, and given starting directions from spawn points instead of base player script.
func set_direction():
	if rotation == 0:
		Global.starting_direction == "up"
	elif rotation == 90:
		Global.starting_direction == "right"
		$Pipe.frame = 2
	elif rotation == 180:
		Global.starting_direction == "down"
	elif rotation == -90:
		$Pipe.frame = 2
		Global.starting_direction == "right"



func _on_enter_pipe_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and teleporterable == true:
		$PowerDown.play()
		Global.targetting_pipe = TargetID
		await get_tree().create_timer(1.2).timeout
		get_tree().change_scene_to_file(world)
		push_teleport()
		if gotoPipe:
			Global.teleport_all = true
