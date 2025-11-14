extends Control
@export var value : int = 0
var score = [
	100,
	200,
	400,
	500,
	800,
	1000,
	2000,
	4000,
	5000,
	8000,
]

func _ready() -> void:
	if value < score.size():
		var label = score[value]
		if value <= 9:
			Global.score += label
			$Label.text = str(label)
	else:
		# Handle the case where value is out of bounds
		$Label.text = str("L0L")
		$"1up".play()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	visible = false
	await get_tree().create_timer(5).timeout
	queue_free()
	
