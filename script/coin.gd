extends Node2D
@export var blocked = false
var underground_sprite = load("res://sprite/dark coin.png")
var overworld_sprite = load("res://sprite/coins.png")
var collected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	block_collect()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.world_type == "underground":
		$Coins.texture = underground_sprite


#runs when coin spawns from block
func block_collect():
	if blocked:
		$AnimationPlayer.play("collect")
		collect()
	else:
		$edible.monitorable = true


#get collected if touched by snakes
func _on_coin_area_area_entered(area: Area2D) -> void:
	if area.name == "Head Area" and not collected:
		collected = true
		$Coins.visible = false
		collect()
	if area.name == "kill":
		$AnimationPlayer.play("collect")

#deletes coin
func _on_coin_sound_finished() -> void:
	queue_free()

var point = preload("res://scenes/score.tscn")
func spawn_score(score):
	var spawn2 = score
	var spawn = point.instantiate()
	spawn.value = spawn2
	spawn.global_position = global_position
	Global.hud.add_child(spawn) #crashing when underground
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	spawn_score(1)
	queue_free()
	
func collect():
	Global.coin += 1
	$coin_sound.play()
	Global.score += 200
