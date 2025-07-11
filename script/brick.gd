extends Node2D
var snake_under = false
var snake_boop = false
var spawnable = false
var timing = false
@export var items: Array[PackedScene] = []
@export var false_block = false
@export var invis_block = false


func _process(delta: float) -> void:

	#bump_up_detect()
	visability()
	keepSpawning()
	


func visability():
	if false_block:
		$AllTheSmallBlocksTogether.frame = 1
	elif invis_block:
		$AllTheSmallBlocksTogether.visible = false

#func bump_up_detect():
	#if snake_under and Global.direction == "up":
		#spawnable = true

func _input(event):
	if event.is_action_pressed("k_up") and snake_under:
		spawn_item()

func spawn_item():
	if Global.snake_status == "small":
		$AnimationPlayer.play("bump")
		$kill.position.y = -13
		await get_tree().create_timer(0.1).timeout
		$kill.position.y = 0
func keepSpawning():
	if spawnable == true and timing == true:
		spawn_item()
		spawnable = false
		await get_tree().create_timer(0.8).timeout
		spawnable = true
		
#make it so that if coin scene then use slightly diff function
func _on_bottom_check_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		if Global.direction == "up":
			spawnable = true
			timing = true
		else: 
			snake_under = true

func _on_bottom_check_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		snake_under = false
		spawnable = false
		timing = false


func _on_brick_area_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and Global.snake_status != "small":
		queue_free()
