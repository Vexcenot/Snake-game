extends Node2D
var winscreen = preload("res://sounds/overworld.wav")
var open = true
var shit = true
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
	if Global.timerDown and Global.timer <= 0 and shit:
		shit = false
		$AnimationPlayer.play("win")
		await get_tree().create_timer(2.36).timeout
		get_tree().change_scene_to_file("res://scenes/win screen.tscn")
