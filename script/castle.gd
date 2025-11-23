extends Node2D
var winscreen = preload("res://scenes/win screen.tscn")
var open = true
var active = true
var next = false
var timerdown
var tick = false

func _ready() -> void:
	timerdown = $"timer down".get_stream_playback()
	

func _on_entrance_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and Global.winning == true and open: 
		Global.timerDown = true
		open = false
		
func _process(delta: float) -> void:
	if Global.timerDown and Global.timer > 0:
		Global.timer -= 1
		Global.score += 50
		timerdown.play_stream(load("res://sounds/timer down.wav"))
		#if tick == false:
			#tick = true
			#$AudioStreamPlayer.play()
			#tick = false
	if Global.timerDown and Global.timer <= 0 and active:
		active = false
		$AnimationPlayer.play("win")
	if Global.winEnd and active == false:
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file.call_deferred("res://scenes/win screen.tscn")#crashes
		set_process(false) 
