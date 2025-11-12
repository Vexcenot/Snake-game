extends Node2D
var winscreen = preload("res://scenes/win screen.tscn")
var open = true
var active = true
func _on_entrance_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and Global.winning == true and open:
		$CastleEnd.visible = true
		Global.timerDown = true
		open = false
		
func _process(delta: float) -> void:
	if Global.timerDown and Global.timer > 0:
		Global.timer -= 1
		Global.score += 50
		$"timer down".play()
	if Global.timerDown and Global.timer <= 0 and active:
		active = false
		$AnimationPlayer.play("win")
	if Global.winEnd and active == false:
		get_tree().change_scene_to_file("res://scenes/win screen.tscn")
		set_process(false) 

func change_to_win_scene():
	get_tree().change_scene_to_file("res://scenes/win screen.tscn")
