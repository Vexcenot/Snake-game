extends CharacterBody2D

@export var active = false
@export var turn2turtle = true
#var turt = preload("res://scenes/fuck.tscn")

var speeder = 200
var gravity = 700 
var speed = speeder
var ignore = false
var timer = 0
var converted = false
var bounced = 0

#movement baby!!!!
func _physics_process(delta: float) -> void:
	timer += 1
	velocity.y += gravity * delta  # Apply gravity
	#if stopped == false and dieing == false:
	velocity.x = speed
	move_and_slide()
	if velocity.x == 0:
			Global.eatable += 1
			queue_free()

#func _ready():
	#spawning()
func _ready() -> void:
	#make it not do this when moving
	if turn2turtle:
		$AnimationPlayer.play("transform")
	if active:
		position.x -= 10
		speed = -speeder

#check if on edge and turns
func _on_left_side_body_entered(body: Node2D) -> void:
	if body.name == "Snek":
		position.x += 10
		speed = speeder
		$AnimationPlayer.play("RESET")

	if body.name == "brick" or "":
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
	speed = 0

#play sprite animation sliding up and enabling movement
func spawning():
		$Mushrooms/AnimationPlayer.play("spawn")
		$Mushrooms/AnimationPlayer/AudioStreamPlayer2D.play()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	converted = true


func _on_left_side_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and ignore == false:
		#position.x += 10

		$".".set_collision_layer_value(1, false)
		$Node2D2/edible2/CollisionShape2D.disabled = false
		
		await get_tree().create_timer(0.01).timeout
		$Node2D2/enemy2.monitorable = true
		$Node2D2/enemy2.monitorable = true
		
		
		await get_tree().create_timer(1.22).timeout
		$Node2D2/enemy.monitorable = true
		
	if area.name == "enemy2":
		die()

func _on_right_side_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and ignore == false:
		#position.x -= 10

		$".".set_collision_layer_value(3, false)
		$Node2D2/enemy2/hurtCollision.disabled = false
		
		await get_tree().create_timer(0.01).timeout
		$Node2D2/enemy2.monitorable = true
		$Node2D2/enemy2.monitorable = true
		
		
		await get_tree().create_timer(1.22).timeout
		$Node2D2/enemy.monitorable = true
	if area.name == "enemy2":
		die()


func _on_top_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and ignore == false:
		position.x += 10

		$".".set_collision_layer_value(1, false)
		$Node2D2/enemy2/hurtCollision.disabled = false
		
		await get_tree().create_timer(0.01).timeout
		$Node2D2/enemy2.monitorable = true
		$Node2D2/enemy2.monitorable = true
		
		
		await get_tree().create_timer(1.22).timeout
		$Node2D2/enemy.monitorable = true

func _on_top_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		ignore = false

func _on_shell_area_entered(area: Area2D) -> void:
	if area.name == "delete":
		queue_free()
	elif area.name == "Head Area" and Global.snake_status != "small":
		bounced += 1
		if Global.playerCombo < 3:
			Global.playerCombo = 2
		spawn_scoreSnake()


func _on_enemy_2_area_entered(area: Area2D) -> void:
	if area.name == "kill":
		die()
		
		
#spawned scene is broken, and all scenes preloaded gets stucl
func turnTurtle():
	pass
	#var spawnTurt = turt.instantiate()
	#get_tree().root.add_child(spawnTurt)
	#spawnTurt.global_position = global_position
	#queue_free()


var point = preload("res://scenes/score.tscn")
#spawn score with snake
func spawn_scoreSnake():
	if Global.playerComboTimer > 0 and Global.playerCombo <= 10:
		Global.playerCombo += 1
	Global.playerComboTimer = 1 
	var spawn = point.instantiate()
	spawn.value = Global.playerCombo
	spawn.global_position = position
	Global.hud.add_child(spawn)
	
#spawn score normally
func spawn_score(score):
	var spawn2 = score
	var spawn = point.instantiate()
	spawn.value = spawn2
	spawn.global_position = position
	Global.hud.add_child(spawn)
