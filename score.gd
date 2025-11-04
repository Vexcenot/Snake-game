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
	"1up"
]

func _ready() -> void:
	var label = score[value]
	$Label.text = str(label)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
