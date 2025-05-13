extends Node2D
var snake_under = false
var snake_boop = false
var spawnable = false
var animated = false
@export var items: Array[PackedScene] = []
@export var false_block = false
@export var invis_block = false


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	bump_up_detect()
	spawn_item()
	visability()
	rest_block()

func visability():
	if false_block:
		$AllTheSmallBlocksTogether.frame = 1
	elif invis_block:
		$AllTheSmallBlocksTogether.visible = false

func bump_up_detect():
	if snake_under and Global.direction == "up":
		spawnable = true

func _input(event):
	if event.is_action_pressed("k_up") and snake_under:
		spawnable = true

func rest_block():
	if items.size() == 0:
		$block_area.monitorable = false
		$block_area.monitoring = false
		invis_block = false
		false_block = false
		$AllTheSmallBlocksTogether.visible = true
		$AllTheSmallBlocksTogether.frame = 7

func spawn_item():
	if items.size() > 0 and spawnable:
		spawnable = false
		var coining = items[0].resource_path == "res://scenes/coin_blocked.tscn"
		if coining:
			$AnimationPlayer.play("bump")
			var coin_instance = items[0].instantiate()
			add_child(coin_instance)
			items.pop_front()
			animated = false
	# Only spawn if there are items left
		else:
			$AnimationPlayer.play("bump")
			$spawn_sound.play()
			$bump_sound.play()
			if animated:
				var spawned_item = items[0].instantiate()
				add_child(spawned_item)
				spawned_item.position.y -= 8
				create_tween().tween_property(spawned_item, "position", Vector2(spawned_item.position.x, spawned_item.position.y - 8), 1.05)
				items.pop_front()
				animated = false
			#when block outta items:




#toggles if snake is under block
func _on_block_area_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		snake_under = true

func _on_block_area_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		snake_under = false
		spawnable = false
		

		
func move_up_16_pixels():
	position.y -= 16


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animated = true


	


		
#make it so that if coin scene then use slightly diff function
