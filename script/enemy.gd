extends CharacterBody2D

var shell = preload("res://scenes/shell.tscn")
@export var speeder = 25
@export var gravity = 700 
@export var avoid_ledge = false
@export var block = false
@export var flippable = false
var speed = -speeder
var activate = false
var leftfloor = 0
var rightfloor = 0
var timer = 0
var head = false
var dead = false
var direction = 0

	
func spriteOrientation():
	if flippable:
		if speed == speeder:
			$Node2D2/Sprite.flip_h = true
		elif speed == -speeder:
			$Node2D2/Sprite.flip_h = false
#movement baby!!!!
func _physics_process(delta: float) -> void:
	if block == false and activate == true and dead == false:

		velocity.x = speed
		velocity.y += gravity * delta  # Apply gravity
		move_and_slide()
		goback()
		spriteOrientation()
		spawnShell()
		turnMover()
		print(direction)
#func _ready():
	#block_spawn()
func kill():
	dead = true
	await get_tree().create_timer(0.001).timeout
	$AnimationPlayer.speed_scale = 1.1
	$AnimationPlayer.play("die")
	$"left bottom".monitorable = false
	$"right bottom".monitorable = false
	$"left side".monitorable = false
	$"right side".monitorable = false
	$edible2.monitorable = false
	$CollisionShape2D.disabled = true

	#queue_free() #add flip animation
func turnMover():
	if velocity.is_zero_approx():
		if speed == speeder:
			speed = -speeder
		elif speed == -speeder:
			speed = speeder
#if bumped wall, turns.
#func _on_left_side_body_entered(body: Node2D) -> void:
	#if dead == false:
		#direction += 1 
#
#func _on_right_side_body_entered(body: Node2D) -> void:
	#if dead == false:
		#direction -= 1 
	#
#func _on_left_side_area_entered(area: Area2D) -> void:
	#if dead == false:
		#if area.name == "enemy" or area.name == "shell":
			#direction += 1 
#
#func _on_right_side_area_entered(area: Area2D) -> void:
	#if dead == false:
		#if area.name == "enemy" or area.name == "shell":
			#direction -= 1 

#play sprite animation sliding up and enabling movement
func block_spawn():
	if block == true:
		$Mushrooms/AnimationPlayer.play("spawn")
		$AudioStreamPlayer2D.play()




func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if dead == false:
		block = false

#LEDGE DETECTION
func goback():
	if dead == false:
		if avoid_ledge:
			if leftfloor <= 0:
				speed = speeder
			elif rightfloor <= 0:
				speed = -speeder

func _on_left_bottom_body_entered(body: Node2D) -> void:
	leftfloor += 1

func _on_right_bottom_body_entered(body: Node2D) -> void:
	rightfloor += 1
	

func _on_left_bottom_body_exited(body: Node2D) -> void:
	leftfloor -= 1
	
func _on_right_bottom_body_exited(body: Node2D) -> void:
	rightfloor -= 1
	
func spawnShell():
	if dead == false:
		if head and Global.direction == "down":
			var shellio = shell.instantiate()
			get_parent().add_child(shellio)
			shellio.global_position = global_position
			queue_free()
	

#turns to shell if touched ontop
func _on_shell_area_entered(area: Area2D) -> void:
	if dead == false:
		if area.name == "Head Area":
			if Global.snake_status != "small" and Global.direction == "down":
				await get_tree().create_timer(0.01).timeout
				$Node2D2/Sprite/enemy.monitorable = false
			else:
				head = true
				await get_tree().create_timer(0.01).timeout
				$Node2D2/Sprite/enemy.monitorable = false


func _on_koopa_top_area_entered(area: Area2D) -> void:
	if dead == false:
		if area.name == "Head Area":
			if Global.snake_status != "small" and Global.direction == "down":
				pass
			else:
				head = true
				await get_tree().create_timer(0.01).timeout
				$Node2D2/Sprite/enemy.monitorable = false

func _on_koopa_top_area_exited(area: Area2D) -> void:
	if dead == false:
		if area.name == "Head Area":
			if Global.snake_status != "small" and Global.direction == "down":
				queue_free()
			else:
				head = false
				await get_tree().create_timer(0.01).timeout
				$Node2D2/Sprite/enemy.monitorable = true



func _on_left_side_area_entered(area: Area2D) -> void:
	if dead == false:
		if area.name == "Head Area":
			$Node2D2/Sprite.visible = false
			await get_tree().create_timer(0.1).timeout
			queue_free()
		elif area.name == "enemy2" or area.name == "fireball" or area.name == "kill":
			kill()
		if area.name == "activate_entity":
			activate = true

func _on_right_side_area_entered(area: Area2D) -> void:
	if dead == false:
		if area.name == "Head Area":
			$Node2D2/Sprite.visible = false
			await get_tree().create_timer(0.1).timeout
			queue_free()
		elif area.name == "enemy2" or area.name == "fireball" or area.name == "kill":
			global_scale.x = -1
			kill()
		if area.name == "delete" and activate:
			print("FUEEKE")
			queue_free()
