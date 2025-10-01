extends CharacterBody2D

@export var avoid_ledge = false
@export var stopped = false
@export var turtle = true
var turt = preload("res://scenes/goomba.tscn")
var speeder = 200
var gravity = 700 
var speed = speeder
var ignore = false
var timer = 0
var converted = false 

#movement baby!!!!
func _physics_process(delta: float) -> void:
	timer += 1
	print($enemy2.monitorable)
	velocity.y += gravity * delta  # Apply gravity
	if stopped == false:
		velocity.x = speed
	move_and_slide()
		
		

#func _ready():
	#spawning()
func _ready() -> void:
	if turtle:
		$AnimationPlayer.play("transform")

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

func die():
	queue_free() #add die animation

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
	converted = true


func _on_left_side_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and ignore == false and stopped == true:
		position.x += 10
		stopped = false
		await get_tree().create_timer(0.1).timeout
		$enemy2.monitorable = true
		
		
		await get_tree().create_timer(1.22).timeout
		$enemy.monitorable = true
	if area.name == "enemy2":
		die()
		


func _on_right_side_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and ignore == false and stopped == true:
		position.x -= 10
		stopped = false
		await get_tree().create_timer(0.1).timeout
		$enemy2.monitorable = true
		$enemy2.monitorable = true
		
		
		await get_tree().create_timer(1.22).timeout
		$enemy.monitorable = true
	if area.name == "enemy2":
		die()


func _on_top_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and ignore == false and stopped == true:
		position.x += 10
		stopped = false
		await get_tree().create_timer(0.1).timeout
		$enemy2.monitorable = true
		$enemy2.monitorable = true
		
		
		await get_tree().create_timer(1.22).timeout
		$enemy.monitorable = true

func _on_top_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		ignore = false
		


#func _on_top_2_area_entered(area: Area2D) -> void:
	#print("CUM")
	#$enemy.monitorable = false


func _on_shell_area_entered(area: Area2D) -> void:
	if area.name == "delete" or area.name == "Head Area" and Global.snake_status != "small":
		print("FUUUUUUUGH")
		queue_free()
		
