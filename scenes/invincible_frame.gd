extends Node2D
var bigsnek = preload("res://sprite/inv big.png")
var smolsnek = preload("res://sprite/inv smol.png")
var poopSprite = preload("res://sprite/poo.png")
var poop = false
var fall = false
var gravity = 400


func _process(delta: float) -> void:
	if Global.snake_status != "small" and poop == false:
		$CharacterBody2D/sprite.texture = bigsnek
	else:
		if poop == false:
			$CharacterBody2D/sprite.texture = smolsnek


func _physics_process(delta: float) -> void:
	if poop:
		$CharacterBody2D.velocity.y += gravity * delta
		$CharacterBody2D.move_and_slide()


func _on_tail_detector_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		$CharacterBody2D/sprite.visible = true
	if area.name == "tail area":
		poop = true
		$CharacterBody2D/sprite.texture = poopSprite
