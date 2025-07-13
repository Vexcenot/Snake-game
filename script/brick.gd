extends Node2D
var snake_under = false
var snake_boop = false
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
	if snake_under:
		spawn_item()

func spawn_item():
	if Global.snake_status == "small" and Global.direction == "up" or Global.direction == "left" or Global.direction == "right":
		$AnimationPlayer.play("bump")
func keepSpawning():
	if snake_under == true:
		spawn_item()
		await get_tree().create_timer(0.8).timeout

		
#make it so that if coin scene then use slightly diff function
func _on_bottom_check_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" :
		snake_under = true
		#if Global.direction == "up":
			#spawnable = true
			#timing = true
		#else: 
			#snake_under = true

func _on_bottom_check_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		snake_under = false
		timing = false


func _on_brick_area_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and Global.snake_status != "small":
		queue_free()
