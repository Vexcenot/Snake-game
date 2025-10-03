extends CharacterBody2D

@export var avoid_ledge = false
@export var stopped = false
@export var turn2turtle = true
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
	#make it not do this when moving
	if turn2turtle:
		$AnimationPlayer.play("transform")

#check if on edge and turns
func _on_left_side_body_entered(body: Node2D) -> void:
	if body.name == "Snek":
		position.x += 10
		speed = speeder
		$AnimationPlayer.play("RESET")

	if body.name == "brick":
		speed = speeder
		$AnimationPlayer.play("RESET")


func _on_right_side_body_entered(body: Node2D) -> void:
	if body.name == "Snek":
		position.x -= 10
		speed = -speeder
		$AnimationPlayer.play("RESET")

	if body.name == "brick" or "":
		speed = -speeder
		$AnimationPlayer.play("RESET")

func die():
	$sprite/AnimationPlayer.play("die")
	$"left bottom".monitoring = false
	$"right bottom".monitoring = false
	$"left side".monitoring = false
	$"right side".monitoring = false
	$edible2.monitorable = false
	$enemy2.monitorable = false
	$enemy.monitorable = false
	$top.monitorable = false
	$shell.monitorable = false
	await get_tree().create_timer(5).timeout
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
		$".".set_collision_layer_value(1, false)
		$enemy2/hurtCollision.disabled = false
		
		await get_tree().create_timer(0.01).timeout
		$enemy2.monitorable = true
		$enemy2.monitorable = true
		
		
		await get_tree().create_timer(1.22).timeout
		$enemy.monitorable = true
		
	if area.name == "enemy2":
		die()
		


func _on_right_side_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and ignore == false and stopped == true:
		position.x -= 10
		stopped = false
		$".".set_collision_layer_value(3, false)
		$enemy2/hurtCollision.disabled = false
		
		await get_tree().create_timer(0.01).timeout
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
		$".".set_collision_layer_value(1, false)
		$enemy2/hurtCollision.disabled = false
		
		await get_tree().create_timer(0.01).timeout
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
		


func _on_enemy_2_area_entered(area: Area2D) -> void:
	if area.name == "kill":
		die()
