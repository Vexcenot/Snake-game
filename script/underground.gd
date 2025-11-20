extends Node2D

func _ready() -> void:
	Global.piping = false
	Global.invincible = false
	Global.world_type = "underground"
	Global.music = "underground"
	Global.playMusic = true
	Global.timeLive = true
	Global.resetCoinAnim = true
