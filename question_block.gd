extends Node2D
var snake_under = false
var snake_boop = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bump_read()
	print(Global.direction)
	


func _on_block_area_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		snake_under = true	

func _on_block_area_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		snake_under = false


func bump_read():
	if snake_under and Input.is_action_pressed("k_up"):
		bump()
	elif snake_under and Global.direction == "up":
		bump()
	else:
		pass

func bump():
	$AnimationPlayer.play("bump")
	
#func bump_active():
	#if snake_boop == true:
		#bump()

#func _on_block_area_inner_area_entered(area: Area2D) -> void:
	#if area.name == "snake nose":
		#snake_boop = true
#
#
#func _on_block_area_inner_area_exited(area: Area2D) -> void:
	#if area.name == "snake nose":
		#snake_boop = false
