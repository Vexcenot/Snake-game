extends CharacterBody2D

var shell = preload("res://scenes/shell.tscn")
var soup = preload("res://scenes/soup.tscn")
var shitake = preload("res://scenes/shitake.tscn")
var point = preload("res://scenes/score.tscn")
enum Sfood {soup, shitake}
@export var Super_Food: Sfood
@export var speeder = 25
@export var gravity = 700 
@export var avoid_ledge = false
@export var block = false
@export var flippable = false
@export var turn_shell = false

var speed = -speeder
var activate = false
var leftfloor = 0
var rightfloor = 0
var timer = 0
var head = false
var dead = false
var direction = 0
var eatable = 0
var live = false
var shellArmed = false
#make var here that assosciates palyer combo to an arrayt with list of points to give out

func _ready():
	await get_tree().create_timer(0.5).timeout
	live = true

#movement baby!!!!
func _physics_process(delta: float) -> void:
	shellTrans()
	if block == false and activate == true and dead == false:
		velocity.x = speed
		velocity.y += gravity * delta  # Apply gravity
		move_and_slide()
		goback()
		spriteOrientation()
		turnMover()
		getEaten()

#spawns food scene
#spawns food scene
func spawn_food():
	var scene_to_spawn
	match Super_Food:
		Sfood.soup:
			scene_to_spawn = soup
		Sfood.shitake:
			scene_to_spawn = shitake
	
	var instance = scene_to_spawn.instantiate()
	# Spawn in the same parent as this enemy
	get_parent().add_child(instance)
	instance.global_position = global_position

#spawn score with snake
func spawn_scoreSnake():
	if Global.playerComboTimer > 0 and Global.playerCombo <= 10:
		Global.playerCombo += 1
	Global.playerComboTimer = 1 
	var spawn = point.instantiate()
	spawn.value = Global.playerCombo
	spawn.global_position = position
	Global.hud.add_child(spawn)
	
#spawn score with shell
func spawn_scoreShell():
	if Global.playerComboTimer > 0 and Global.playerCombo <= 10:
		Global.shellCombo += 1
	if Global.shellCombo < 4:
		Global.shellCombo = 3
	#Global.playerComboTimer = 1 
	var spawn = point.instantiate()
	spawn.value = Global.shellCombo
	spawn.global_position = position
	Global.hud.add_child(spawn)

#spawn score normally
func spawn_score(score):
	var spawn2 = score
	var spawn = point.instantiate()
	spawn.value = spawn2
	spawn.global_position = position
	Global.hud.add_child(spawn)
	

#direction reverser
func turnMover():
	if velocity.is_zero_approx():
		if speed == speeder:
			speed = -speeder
		elif speed == -speeder:
			speed = speeder

#flips sprite depending on current direction
func spriteOrientation():
	if flippable:
		if speed == speeder:
			$Node2D2/Sprite.flip_h = true
		elif speed == -speeder:
			$Node2D2/Sprite.flip_h = false
		


#disabled everything and dies
func kill():
	$kill.play()
	spawn_score(0)
	dead = true
	await get_tree().create_timer(0.001).timeout
	$AnimationPlayer.speed_scale = 1.1
	$AnimationPlayer.play("die")
	disable()


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
	

func _on_koopa_top_area_entered(area: Area2D) -> void:
	if dead == false:
		if area.name == "Head Area":
			if Global.snake_status != "small" and Global.direction == "down":
				pass
			else:
				head = true
				await get_tree().create_timer(0.01).timeout
				$Node2D2/Sprite/enemy.monitorable = false

#right area detect
func _on_koopa_top_area_exited(area: Area2D) -> void:
	if dead == false:
		if area.name == "Head Area":
				head = false
				await get_tree().create_timer(0.01).timeout
				$Node2D2/Sprite/enemy.monitorable = true

#left area detect
func _on_left_side_area_entered(area: Area2D) -> void:
	if dead == false:
		if area.name == "enemy2" or area.name == "kill" and live:
			kill()
		if area.name == "fireball":
			spawn_food()
			spawn_score(1)
			queue_free()
		if area.name == "activate_entity":
			activate = true

#right are detect
func _on_right_side_area_entered(area: Area2D) -> void:
	if dead == false:
		if area.name == "enemy2":
			kill()
		if area.name == "kill" and live:
			spawn_score(0)
			kill()
		if area.name == "fireball":
			spawn_food()
			queue_free()
		if area.name == "delete" and activate:
			print("FUEEKE")
			queue_free()

#disable layers to not interact with anything
func disable():
	$"left bottom".monitorable = false
	$"right bottom".monitorable = false
	$"left side".monitorable = false
	$"right side".monitorable = false
	$edible2.monitorable = false
	$CollisionShape2D.disabled = true
	$enemy.monitorable = false
	$enemy.monitoring = false
	$top.monitoring = false

#becomes shell if snake touches its top
func _on_top_area_entered(area: Area2D) -> void:
	if turn_shell and area.name == "Head Area":
		shellArmed = true
func _on_top_area_exited(area: Area2D) -> void:
	if turn_shell and area.name == "Head Area":
		shellArmed = false
		
func shellTrans():
	if shellArmed and Global.direction == "down":
		spawn_score(0)
		var enemy_instance = shell.instantiate()
		disable()
		get_parent().add_child(enemy_instance)  # Changed from get_tree().root
		enemy_instance.global_position = position
		global_position.y = 99999
		await get_tree().create_timer(0.1).timeout
		queue_free()

#becomes eatad if snake eats it
func _on_enemy_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		eatable += 1 

#deletes itself if eaten by snake
func getEaten():
	if eatable >= 1 and Global.snake_status != "small":
		spawn_scoreSnake()
		queue_free()
