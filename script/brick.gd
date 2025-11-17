extends Node2D
var snake_under = false
var snake_boop = false
var timing = false
var live = true
@export var items: Array[PackedScene] = []
@export var false_block = false
@export var invis_block = false
var underground_sprite = load("res://sprite/dark stuff.png")
var overworld_sprite = load("res://sprite/all the small blocks together.png")

func _process(delta: float) -> void:
	visability()
	keepSpawning()
	if Global.world_type == "underground":
		$AllTheSmallBlocksTogether.texture = underground_sprite
	
func _ready() -> void:
	if Global.world_type == "underground":
		$AllTheSmallBlocksTogether.texture = underground_sprite

func visability():
	if false_block:
		$AllTheSmallBlocksTogether.frame = 1
	elif invis_block:
		$AllTheSmallBlocksTogether.visible = false

#func _input(event):
	#if snake_under:
		#spawn_item()

func spawn_item():
	if Global.direction != "down":
		$AnimationPlayer.play("bump")
		#$bump.play()
		
		
func keepSpawning():
	if snake_under == true and live:
		live = false
		spawn_item()
		await get_tree().create_timer(0.8).timeout
		live = true


#make it so that if coin scene then use slightly diff function
func _on_bottom_check_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" :
		snake_under = true


func _on_bottom_check_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		snake_under = false
		timing = false


func _on_brick_area_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and Global.snake_status != "small":
		Global.score += 50
		queue_free()
