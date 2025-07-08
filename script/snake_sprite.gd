extends Sprite2D
var bigsnek = preload("res://sprite/big snake.png")
var smolsnek = preload("res://sprite/smol snake.png")
@onready var sprite = $"."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_float) -> void:
	current_powerup()

func current_powerup():
	if Global.snake_status == "big":
		sprite.texture = bigsnek
	elif Global.snake_status == "small":
		sprite.texture = smolsnek
	


#func _on_tail_area_area_exited(area: Area2D) -> void:



#func _on_tail_area_area_entered(area: Area2D) -> void:
	#if area.name == "entrance":
		#$".".visible = false
