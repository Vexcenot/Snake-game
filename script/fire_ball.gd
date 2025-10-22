extends Node2D
@export var move_state = 0
var bounce_state = 0
var speed = 200
var explode = false
var explode2 = true
var halfSpeed = 0
func _ready() -> void:
	Global.active_balls += 1
	
	if Global.direction == "right":
		move_state = 0
	elif Global.direction == "left":
		move_state = 1
	elif Global.direction == "up":
		move_state = 2
	elif Global.direction == "down":
		move_state = 3

func _process(delta: float) -> void:
	exploding()
	if move_state == 0 or move_state == 3:
		position.x += speed*delta
	elif move_state == 1:
		position.x -= speed*delta
	elif move_state == 2:
		position.x -= speed*delta
		position.y -= speed*delta
		await get_tree().create_timer(0.1).timeout
		position.y += speed*delta
	#bounces when hits groundd
	halfSpeed += 855*delta
	if bounce_state == 2:
		position.y -= speed*delta
	elif bounce_state == 1:
		position.y += halfSpeed*delta
	else:
		position.y += speed*delta


#set bounce status
func _on_bottom_collision_body_entered(body: Node2D) -> void:
	if body.name != "Snek" or body.name != "tail_collision":
		bounce_state = 2
		await get_tree().create_timer(0.08).timeout
		halfSpeed = 0
		bounce_state = 1


func exploding():
	if explode and explode2:
		explode2 = false
		Global.active_balls -= 1
		speed = 0
		$AnimationPlayer.play("explode")
		$fireball.monitorable = false
		await get_tree().create_timer(1).timeout
		queue_free()

func _on_side_collision_body_entered(body: Node2D) -> void:
	if body.name != "Snek" or body.name != "tail_collision":
		explode = true


func _on_side_collision_area_entered(area: Area2D) -> void:
	if area.name == "oob":
		explode = true
		

func _on_fireball_area_entered(area: Area2D) -> void:
	if area.name == "left side" or area.name == "right side":
		explode = true
