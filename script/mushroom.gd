extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		#set_power("big")
		queue_free()


#changes current power of snake then despawns scene
func set_power(power: String):
	var current_power = Global.snake_status
	var blink_sec = 0.1
	get_tree().paused = true
	$AudioStreamPlayer.play()
	Global.snake_status = power
	#$RigidBody2D/Mushrooms.visible = false
	for i in range(4):
		Global.snake_status = current_power
		await get_tree().create_timer(blink_sec).timeout
		Global.snake_status = power
		await get_tree().create_timer(blink_sec).timeout  # Wait again before switching back
	get_tree().paused = false
	queue_free()
