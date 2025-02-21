extends Sprite2D
var bigsnek = preload("res://sprite/big snake.png")
var smolsnek = preload("res://sprite/smol snake.png")
@onready var sprite = $"."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_powerup()

func current_powerup():
	if Global.snake_status == "big":
		sprite.texture = bigsnek
	elif Global.snake_status == "small":
		sprite.texture = smolsnek
		
