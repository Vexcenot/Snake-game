extends Node

func _ready() -> void:
	Global.piping = false
	Global.invincible = false
	if Global.title == false:
		Global.timeLive = true
		$"bg music".play()
	if Global.play:
		$logotitle.visible = false
	Global.world_type = "overworld"
	Global.loadedWorld = "res://scenes/main.tscn"
	Global.music = "overworld"
	Global.playMusic = true
	Global.resetCoinAnim = true
