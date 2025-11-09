extends Sprite2D
var bigsnek = preload("res://sprite/big snake.png")
var smolsnek = preload("res://sprite/smol snake.png")
var firesnek = preload("res://sprite/fire 2.png") 
var midsnek = preload("res://sprite/mid snake.png")
var black = preload("res://sprite/mid snake.png")
var touched_pole = false
var fuck = false
@onready var sprite = $"."

#func _ready() -> void:
	#if Global.spawn_facing == 1:
		#$".".rotate(90)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_float) -> void:
	pausing()
	current_powerup()
	blinking()

func pausing():
	if Global.paused == true:
		set_process_mode(PROCESS_MODE_INHERIT)

	else:
		set_process_mode(PROCESS_MODE_ALWAYS)

func current_powerup():
	if Global.snake_status == "big":
		sprite.texture = bigsnek
	elif Global.snake_status == "small":
		sprite.texture = smolsnek
	elif Global.snake_status == "fire":
		$"../AnimationPlayer".play("fire_up")
	elif Global.snake_status == "fire2":
		sprite.texture = firesnek

func blinking():
	if Global.invincible:
		visible = not visible
	else:
		visible = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "winarea":
		z_index = 1
	#if area.name == "inv_area":
		#$AnimationPlayer.play("invincible")
		
