extends Node2D
var snake_under = false
var snake_boop = false
var spawnable = false
var timing = false
var keep = false
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

#func _input(event):
	#if event.is_action_pressed("k_up") and snake_under:
		#spawn_item()

func rest_block():
	if items.size() == 0:
		invis_block = false
		false_block = false
		$AllTheSmallBlocksTogether.visible = true
		$AllTheSmallBlocksTogether.frame = 7
		await get_tree().create_timer(0.8).timeout
		$block_area.monitorable = false
		$block_area.monitoring = false



func spawn_item():
	if items.size() > 0:
		await get_tree().create_timer(0.1).timeout
		var coining = items[0].resource_path == "res://scenes/coin.tscn"
		var mushrooming = items[0].resource_path == "res://scenes/mushroom.tscn"
		if coining:
			$AnimationPlayer.play("bump")
			var coin_instance = items[0].instantiate()
			add_child(coin_instance)
			items.pop_front()
		else:
			if mushrooming and Global.snake_status != "small":
				print('jack')
				items[0] = load("res://scenes/fire_flower.tscn")
			
			$AnimationPlayer.play("bump")
			$spawn_sound.play()
			$bump_sound.play()
			var spawned_item = items[0].instantiate()
			add_child(spawned_item)
			spawned_item.position.y
			create_tween().tween_property(spawned_item, "position", Vector2(spawned_item.position.x, spawned_item.position.y - 8), 1.05)
			items.pop_front()
	
	print("shiiid")


func keepSpawning():
	if spawnable and keep:
		spawn_item()
		spawnable = false
		await get_tree().create_timer(0.8).timeout
		if keep:
			spawnable = true
	elif spawnable:
		spawn_item()
		spawnable = false
#toggles if snake is under block
func _on_block_area_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		if Global.direction == "up":
			keep = true
			spawnable = true
		else: 
			spawnable = true



			

func _on_block_area_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		snake_under = false
		spawnable = false
		timing = false
		keep = false
		$kill/CollisionShape2D.disabled = true

		

		
func move_up_16_pixels():
	position.y -= 16


	


		
#make it so that if coin scene then use slightly diff function
