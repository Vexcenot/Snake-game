extends Node2D
@export var move_state = 0
var bounce_state = false
var speed = 0.7
func _ready() -> void:
	if Global.direction == "right":
		move_state = 0
	elif Global.direction == "left":
		move_state = 1
	elif Global.direction == "up":
		move_state = 2
	elif Global.direction == "down":
		move_state = 3

func _process(delta: float) -> void:
	if move_state == 0 or move_state == 3:
		position.x -= speed
	elif move_state == 1 or move_state == 2:
		position.x += speed
	#bounces when hits groundd
	if bounce_state:
		position.y -= speed
	else:
		position.y += speed

func _on_bottom_collision_body_entered(body: Node2D) -> void:
	bounce_state = true
	await get_tree().create_timer(0.2).timeout
	bounce_state = false



func _on_side_collision_body_entered(body: Node2D) -> void:
	queue_free()


func _on_bottom_collision_area_entered(area: Area2D) -> void:
	if area.name == "enemy":
		queue_free()
