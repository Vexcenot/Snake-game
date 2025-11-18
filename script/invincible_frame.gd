extends Node2D
var bigsnek = preload("res://sprite/inv big.png")
var smolsnek = preload("res://sprite/inv smol.png")
var poopSprite = preload("res://sprite/poo.png")
var poop = false
var fall = false
var gravity = 400
var tailing = 0


func _ready() -> void:
	if poop == false:
		Global.music = "invincible"
		Global.playMusic = true

func _process(delta: float) -> void:
	print(tailing)
	if Global.snake_status != "small" and poop == false:
		$CharacterBody2D/sprite.texture = bigsnek
	else:
		if poop == false:
			$CharacterBody2D/sprite.texture = smolsnek
	if Global.dead:
		visible = false


func _physics_process(delta: float) -> void:
	if poop:
		$CharacterBody2D.velocity.y += gravity * delta
		$CharacterBody2D.move_and_slide()


func _on_tail_detector_area_exited(area: Area2D) -> void:
	if area.name == "Head Area":
		visible = true
	if area.name == "tail area":
		tailing -= 1
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		if tailing <= 0 and poop == false:
			poop = true
			$CharacterBody2D/sprite.texture = poopSprite
			$AudioStreamPlayer.play()
			Global.playMusic = true
		


func _on_tail_detector_area_entered(area: Area2D) -> void:
	if area.name == "tail area":
		tailing += 1
