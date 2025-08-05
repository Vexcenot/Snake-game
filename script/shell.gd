extends CharacterBody2D

var speeder = 200
var gravity = 700 
@export var avoid_ledge = false
@export var stopped = false
var speed = speeder
var ignore = false

#movement baby!!!!
func _physics_process(delta: float) -> void:
	if stopped == false:
		velocity.x = speed
		velocity.y += gravity * delta  # Apply gravity
		move_and_slide()

#func _ready():
	#spawning()

#check if on ledge and turns.
func _on_side_checks_body_exited(body: Node2D) -> void:
	if speed == speeder and avoid_ledge == true:
		speed = -speeder
	elif speed == -speeder and avoid_ledge == true:
		speed = speeder

#check if on edge and turns
func _on_left_side_body_entered(body: Node2D) -> void:
	if body.name == "Snek":
		position.x += 10
	speed = speeder


func _on_right_side_body_entered(body: Node2D) -> void:
	if body.name == "Snek":
		position.x -= 10
	speed = -speeder



func set_speed():
	if stopped == false:
		speed = speeder


#play sprite animation sliding up and enabling movement
func spawning():
	if stopped == true:
		$Mushrooms/AnimationPlayer.play("spawn")
		$Mushrooms/AnimationPlayer/AudioStreamPlayer2D.play()


##deletes when being touched by head
#func _on_mushroom_area_entered(area: Area2D) -> void:
	#if area.name == "Head Area":
		##set_power("big")
		#queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	stopped = false


func _on_left_side_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and ignore == false and stopped == true:
		$enemy2.monitorable = true
		stopped = false
		position.x += 10
		await get_tree().create_timer(1.22).timeout
		$enemy.monitorable = true
		


func _on_right_side_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and ignore == false and stopped == true:
		$enemy2.monitorable = true
		stopped = false
		position.x -= 10
		await get_tree().create_timer(1.22).timeout
		$enemy.monitorable = true


func _on_top_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		stopped = true
		ignore = true

func _on_top_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		ignore = false


#func _on_top_2_area_entered(area: Area2D) -> void:
	#print("CUM")
	#$enemy.monitorable = false


func _on_shell_area_entered(area: Area2D) -> void:
	if area.name == "delete":
		print("FUUUUUUUGH")
		queue_free()
