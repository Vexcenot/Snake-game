extends Node2D
var shit = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func _on_winarea_area_entered(area: Area2D) -> void:
	#if area.name == "Head Area":
		#$AnimationPlayer.play("flagdown")


func _on_winarea_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		$brick/StaticBody2D.set_collision_layer_value(1, false)
		if Global.direction == "left" and shit == true:
			$AnimationPlayer.play("brick down")
		


func _on_endpost_area_entered(area: Area2D) -> void:
	if area.name == "Head Area":
		shit = true


func _on_endpost_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		shit = false  
