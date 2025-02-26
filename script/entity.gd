extends CharacterBody2D

@export var speeder = 30
@export var gravity = 350  # Default Godot gravity in pixels per second squared
@export var avoid_ledge = false
@export var block = false
var speed = speeder


#movement baby!!!!
func _physics_process(delta: float) -> void:
	velocity.x = speed
	velocity.y += gravity * delta  # Apply gravity
	move_and_slide()

#check if on ledge and turns.
func _on_side_checks_body_exited(body: Node2D) -> void:
	if speed == speeder and avoid_ledge == true:
		speed = -speeder
		print("fuck1")
	elif speed == -speeder and avoid_ledge == true:
		speed = speeder
		print("fuck2")



func set_speed():
	if block == false:
		speed = speeder


#func _ready():
	#set_speed()

#play sprite animation sliding up and enabling movement
func block_spawn():
	if block == true:
		pass


#deletes when being touched by head
func _on_mushroom_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		#set_power("big")
		queue_free()


func _on_left_side_body_entered(body: Node2D) -> void:
	speed = speeder
	print("shit")


func _on_right_side_body_entered(body: Node2D) -> void:
	speed = -speeder
