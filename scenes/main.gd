extends Node

func _ready() -> void:
	if Global.play:
		$logotitle.visible = false
	Global.world_type = "overworld"
	Global.loadedWorld = "res://scenes/main.tscn"
	Global.music = "overworld"
	Global.playMusic = true
