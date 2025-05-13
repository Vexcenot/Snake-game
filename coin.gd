extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	block_collect()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func block_collect():
	$AnimationPlayer.play("collect")
	

#get collected if touched by snakes
func _on_coin_area_area_entered(area: Area2D) -> void:
	if area.name == "winarea":
		return


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("fuck")
