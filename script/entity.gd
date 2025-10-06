extends CharacterBody2D

var speeder = 50
var gravity = 700 
@export var avoid_ledge = false
@export var stopped = false
var speed = speeder
var killable = false
var jump_force = 150
#movement baby!!!!
func _physics_process(delta: float) -> void:
	if stopped == false:
		velocity.x = speed
		velocity.y += gravity * delta  # Apply gravity
		move_and_slide()

func _ready():
	await get_tree().create_timer(0.1).timeout
	killable = true

#check if on ledge and turns.
func _on_side_checks_body_exited(body: Node2D) -> void:
	if speed == speeder and avoid_ledge == true:
		speed = -speeder
		print("fuck1")
	elif speed == -speeder and avoid_ledge == true:
		speed = speeder
		print("fuck2")

#check if on edge and turns
func _on_left_side_body_entered(body: Node2D) -> void:
	speed = speeder
	print("shit")


func _on_right_side_body_entered(body: Node2D) -> void:
	speed = -speeder



func set_speed():
	if stopped == false:
		speed = speeder


#play sprite animation sliding up and enabling movement
func spawning():
	if stopped == true:
		$Mushrooms/AnimationPlayer.play("spawn")
		$Mushrooms/AnimationPlayer/AudioStreamPlayer2D.play()


#deletes when being touched by head
func _on_mushroom_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		queue_free()

			
		




func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	stopped = false


func _on_bumpable_area_entered(area: Area2D) -> void:
	if area.name == "kill" and killable:
		velocity.y -= jump_force
		if speed == speeder:
			speed = -speeder
		elif speed == -speeder:
			speed = speeder
