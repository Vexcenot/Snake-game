extends Node
var bgMusic = AudioServer.get_bus_index("music")
var snake_status : String = "small"
var direction : String = "left"
var hitting : bool = false
var entranceStopper : bool = false
var winning : bool = false
var active_balls : int = 0
var visible : bool = true
var teleport_x : float = 0
var teleport_y : float = 0
var cam_telex : float = 0
var cam_teley : float = 0
var bonus_length : int = 0
var spawn_facing : String = ""
var teleport_all : bool = false
var teleport_all2 : bool  = false
var camera_limit : float  = 0
var targetting_pipe : String
var starting_direction : String = "right"
var stop_moving : bool = false
var still_stop : bool = false
var invincible : bool = false
var paused : bool = false
var world_type : String = "default"
var eatable : int = 0
var loadedWorld : String = ""
var spawnCoordx : float = 0
var spawnCoordy : float = 0
var camCoordy : float = 0
var snakePosX : float = 0
var checkPointable : bool = false
var checkPointable2 : bool = false
var lowTimer : bool = false
var playMusic : bool = false
var music : String = "none"
var dead : bool = false
var play : bool = false
var piping : bool = false
var fullscreen : bool = false

#########################################################
var ogTime = 400 #dont need rest
var multiplayers : bool = false #remember to false this
var title : bool = true #remember to true this ##################################################
var demoOgTime = 8
###########################################################
var demoTimer = demoOgTime
var timeUp : bool = false
var timeLive : bool = false
var timeStart : bool = false
var demo : bool = false
var pausable : bool = false
var timer = ogTime #dont need rest
var score = 0 #dont reset until new game
var playerComboTimer = 0
var playerCombo = 0
var shellComboTimer = 0
var shellCombo = 0
var lowTime : bool = false
var hud
var debug : bool = false
var topScore = 0 #dont reset
var purgatory : bool = false
var eaten : int = 0
var ogSpeed = 0.3
var snake_speed : float = ogSpeed
var resetCoinAnim : bool = false #resets in world load
var coin : int = 0 #resets in menu script
var timerDown : bool = false
var winEnd : bool = false

#func _ready() -> void:
	#bgMusic = AudioServer.get_bus_index("music")

func _process(delta: float) -> void:
	#print(score)
	if playerComboTimer > 0:
		playerComboTimer -= 1 * delta
	if playerComboTimer <= 0:
		playerCombo = 0
	if shellComboTimer > 0:
		shellComboTimer -= 1 * delta
	if shellComboTimer <= 0:
		shellCombo = 0
	if eaten >= 3:
		eaten = 0
		snake_speed -= 0.02
	print(demo)
		

func reset():
	unmuteMusic()
	demo = false
	demoTimer = demoOgTime
	snake_speed = ogSpeed
	winEnd = false
	timerDown = false
	lowTime = false
	lowTimer = false
	pausable = false
	timeStart = false
	timeLive = false
	timeUp = false
	title = true
	multiplayers = false
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
	#world_type = "default"
	eatable = 0
	dead = false
	if score > topScore:
		topScore = score
	get_tree().paused = false

#for when checkpoints get added
func resetAll():
	reset()
	loadedWorld = ""
	spawnCoordx = 0
	spawnCoordy = 0
	camCoordy = 0
	snakePosX = 0
	checkPointable = false
	checkPointable2 = false
	purgatory = false

func die(): #make it load gameover first
	get_tree().paused = false
	if loadedWorld != "":
		get_tree().change_scene_to_file("res://scenes/gameover.tscn")
	else:
		get_tree().reload_current_scene()
		
func _input(event):
	demoTimer = demoOgTime
	if demo:
		resetAll()
		get_tree().reload_current_scene()
	if event.is_action_pressed("fullscreen"):
		if fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			fullscreen = false
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen = true
		
func muteMusic():
	AudioServer.set_bus_mute(bgMusic, true)
	
func unmuteMusic():
	AudioServer.set_bus_mute(bgMusic, false)
