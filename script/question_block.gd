extends Node2D
var snake_under = false
var snake_boop = false
var spawnable = false
var timing = false
@export var items: Array[PackedScene] = []
@export var false_block = false
@export var invis_block = false


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	#bump_up_detect()
	visability()
	rest_block()
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

func rest_block():
	if items.size() == 0:
		$block_area.monitorable = false
		$block_area.monitoring = false
		invis_block = false
		false_block = false
		$AllTheSmallBlocksTogether.visible = true
		$AllTheSmallBlocksTogether.frame = 7
		print("fuck")

func spawn_item():
	if items.size() > 0:
		var coining = items[0].resource_path == "res://scenes/coin.tscn"
		if coining:
			$AnimationPlayer.play("bump")
			var coin_instance = items[0].instantiate()
			add_child(coin_instance)
			items.pop_front()
		else:
			$AnimationPlayer.play("bump")
			$spawn_sound.play()
			$bump_sound.play()
			var spawned_item = items[0].instantiate()
			add_child(spawned_item)
			spawned_item.position.y -= 8
			create_tween().tween_property(spawned_item, "position", Vector2(spawned_item.position.x, spawned_item.position.y - 8), 1.05)
			items.pop_front()

func keepSpawning():
	if spawnable == true and timing == true:
		spawn_item()
		spawnable = false
		await get_tree().create_timer(0.6).timeout
		spawnable = true

#toggles if snake is under block
func _on_block_area_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		if Global.direction == "up":
			spawnable = true
			timing = true
		else: 
			snake_under = true

			

func _on_block_area_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		snake_under = false
		spawnable = false
		timing = false
		

		
func move_up_16_pixels():
	position.y -= 16


	


		
#make it so that if coin scene then use slightly diff function
