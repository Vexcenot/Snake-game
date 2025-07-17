extends Sprite2D
var bigsnek = preload("res://sprite/big snake.png")
var smolsnek = preload("res://sprite/smol snake.png")
var firesnek = preload("res://sprite/fire snake.png")
var touched_pole = false
@onready var sprite = $"."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_float) -> void:
	current_powerup()

func current_powerup():
	if Global.snake_status == "big":
		sprite.texture = bigsnek
	elif Global.snake_status == "small":
		sprite.texture = smolsnek
	elif Global.snake_status == "fire":
		$"../AnimationPlayer".play("fire_up")
	elif Global.snake_status == "fire2":
		sprite.texture = firesnek


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "winarea":
		z_index = 1
