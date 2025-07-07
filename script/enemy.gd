extends CharacterBody2D

@export var speeder = 25
@export var gravity = 700 
@export var avoid_ledge = false
@export var block = false
var speed = -speeder
var activate = false


#movement baby!!!!
func _physics_process(delta: float) -> void:
	if block == false and activate == true:
		velocity.x = speed
		velocity.y += gravity * delta  # Apply gravity
		move_and_slide()

#func _ready():
	#block_spawn()

#check if on ledge and turns.
func _on_side_checks_body_exited(body: Node2D) -> void:
	if speed == speeder and avoid_ledge == true:
		speed = -speeder

	elif speed == -speeder and avoid_ledge == true:
		speed = speeder

#if bumped wall, turns.
func _on_left_side_body_entered(body: Node2D) -> void:
	speed = speeder

func _on_right_side_body_entered(body: Node2D) -> void:
	speed = -speeder



func set_speed():
	if block == false:
		speed = speeder


#play sprite animation sliding up and enabling movement
func block_spawn():
	if block == true:
		$Mushrooms/AnimationPlayer.play("spawn")
		$Mushrooms/AnimationPlayer/AudioStreamPlayer2D.play()


#deletes when being touched by head
func _on_mushroom_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and Global.snake_status != "small":
		queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	block = false




func _on_enemy_area_entered(area: Area2D) -> void:
	if area.name == "activate_entity":
		activate = true
