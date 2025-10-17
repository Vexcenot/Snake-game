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
	if false_block or invis_block:
		$AnimationPlayer.stop()
	if invis_block:
		$brick.set_collision_layer_value(1, false)

func _process(delta: float) -> void:
	#bump_up_detect()
	visability()
	rest_block()
	keepSpawning()

#handles block appearence
func visability():
	if false_block:
		$Node2D/AllTheSmallBlocksTogether.frame = 1
	elif invis_block:
		$Node2D/AllTheSmallBlocksTogether.visible = false


#turns block into empty brick when empty
func rest_block():
	if items.size() == 0:
		$AnimationPlayer.stop()
		$Node2D/AllTheSmallBlocksTogether.frame = 7
		invis_block = false
		false_block = false
		$Node2D/AllTheSmallBlocksTogether.visible = true
		$Node2D/AllTheSmallBlocksTogether.frame = 7
		await get_tree().create_timer(0.8).timeout
		$block_area.monitorable = false
		$block_area.monitoring = false


func spawn_item():
	$brick.set_collision_layer_value(1, true)
	#make it not kill the enemy coming out of it
	if Global.snake_status == "small" and Global.direction == "up" or Global.direction == "left" or Global.direction == "right":
		$Node2D/AnimationPlayer.play("bump")
		#$kill/CollisionShape2D.disabled = false
	#else:
		#$kill/CollisionShape2D.disabled = true
	if items.size() > 0:
		await get_tree().create_timer(0.1).timeout
		var coining = items[0].resource_path == "res://scenes/coin.tscn"
		var mushrooming = items[0].resource_path == "res://scenes/mushroom.tscn"
		var coin_block = "res://scenes/coin block.tscn"

		#handles spawning coin
		if coining:
			$Node2D/AnimationPlayer.play("bump")
			items[0] = load(coin_block)
			var coin_instance = items[0].instantiate()
			add_child(coin_instance)
			items.pop_front()
		#replaces mushroom with fire flower if snake already big
		else:
			if mushrooming and Global.snake_status != "small":
				items[0] = load("res://scenes/fire_flower.tscn")
		#spawns item normally
			$spawn_sound.play()
			$bump_sound.play()
			var spawned_item = items[0].instantiate()
			add_child(spawned_item)
			#spawned_item.position.y
			create_tween().tween_property(spawned_item, "position", Vector2(spawned_item.position.x, spawned_item.position.y - 8), 1.05)
			items.pop_front()



#handles snake staying under block
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


#if snake leaves
func _on_block_area_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		snake_under = false
		spawnable = false
		timing = false
		keep = false
