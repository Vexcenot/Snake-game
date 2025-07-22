extends Node2D
@export var move_state = 0
var bounce_state = false
var speed = 1.8
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
		position.x += speed
	elif move_state == 1:
		position.x -= speed
	elif move_state == 2:
		position.x -= speed
		position.y -= speed
		await get_tree().create_timer(0.1).timeout
		position.y += speed
	#bounces when hits groundd
	if bounce_state:
		position.y -= speed
	else:
		position.y += speed

func _on_bottom_collision_body_entered(body: Node2D) -> void:
	if body.name != "Snek" or body.name != "tail_collision":
		bounce_state = true 
		await get_tree().create_timer(0.2).timeout
		bounce_state = false

func explode():
	speed = 0
	$AnimationPlayer.play("explode")
	$fireball.monitorable = false
	await get_tree().create_timer(1).timeout
	queue_free()

func _on_side_collision_body_entered(body: Node2D) -> void:
	if body.name != "Snek" or body.name != "tail_collision":
		explode() #replace quefree with unique explode sprite


#func _on_bottom_collision_area_entered(area: Area2D) -> void:
	#if area.name == "enemy":
		#queue_free()#replace quefree with unique explode sprite


func _on_side_collision_area_entered(area: Area2D) -> void:
	if area.name == "oob":
		queue_free()


func _on_fireball_area_entered(area: Area2D) -> void:
	if area.name == "enemy":
		explode()#replace quefree with unique explode sprite
