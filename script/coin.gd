extends Node2D
@export var blocked = false
var collected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	block_collect()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#runs when coin spawns from block
func block_collect():
	if blocked:
		$AnimationPlayer.play("collect")
		$coin_sound.play()
	else:
		$edible.monitorable = true

		

#get collected if touched by snakes
func _on_coin_area_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and not collected:
		collected = true
		$Coins.visible = false
		$coin_sound.play()
	if area.name == "kill":
		$AnimationPlayer.play("collect")
		


func _on_coin_sound_finished() -> void:
	queue_free()
