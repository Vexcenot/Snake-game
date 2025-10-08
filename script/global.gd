extends Node

var snake_status = "small"
var direction = "left"
var hitting = false
var entranceStopper = false
var winning = false
var active_balls = 0
var visible = true
var teleport_x = 0
var teleport_y = 0
var cam_telex = 0
var cam_teley = 0
var bonus_length = 0
var spawn_facing
var teleport_all = false
var teleport_all2 = false
var camera_limit = 0
var targetting_pipe : String
var starting_direction = "right"
var stop_moving = false
var still_stop = false
var invincible = false
var invicible2 = false
