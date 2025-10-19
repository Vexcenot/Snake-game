extends Node

var snake_status : String = "small"
var direction : String = "left"
var hitting : bool = false
var entranceStopper : bool = false
var winning : bool = false
var active_balls : int = 0
var visible : bool = true
var teleport_x : int = 0
var teleport_y : int = 0
var cam_telex : int = 0
var cam_teley : int = 0
var bonus_length : int = 0
var spawn_facing : String = ""
var teleport_all : bool = false
var teleport_all2 : bool  = false
var camera_limit : int  = 0
var targetting_pipe : String
var starting_direction : String = "right"
var stop_moving : bool = false
var still_stop : bool = false
var invincible : bool = false
var paused : bool = false
var world_type : String = "default"
var eatable : int = 0
var loadedWorld : String = ""
var spawnCoordx : int = 0
var spawnCoordy : int = 0

func resetAll():
	snake_status = "small"
	direction = "left"
	hitting = false
	entranceStopper = false
	winning = false
	active_balls = 0
	visible = true
	teleport_x = 0
	teleport_y = 0
	cam_telex = 0
	cam_teley = 0
	bonus_length = 0
	spawn_facing = ""
	teleport_all = false
	teleport_all2 = false
	camera_limit = 0
	targetting_pipe = ""
	starting_direction = "right"
	stop_moving = false
	still_stop = false
	invincible = false
	paused = false
	world_type = "default"
	eatable = 0
	get_tree().paused = false
	if loadedWorld != "":
		get_tree().change_scene_to_file(loadedWorld)
	else:
		get_tree().reload_current_scene()
