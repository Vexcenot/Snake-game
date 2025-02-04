extends Node
@export var snake_scene : PackedScene

#game variables
var score : int 
var game_started : bool = false

#grid
var cells : int = 20
var cell_size : int = 50

#snake varriables
var old_data : Array
var snake_data : Array
var snake : Array

#movement varriables
var start_pos = Vector2(9, 9)
var up = Vector2(0, -1)
var down = Vector2(0, 1)
var left = Vector2(-1, 0)
var right = Vector2(1, 0)
var move_direction : Vector2
var can_move: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


func new_game():
	score = 0
	move_direction = up
	can_move = true
	generate_snake()
	
func generate_snake():
	old_data.clear()
	snake_data.clear()
	snake.clear()
	for i in range(3):
		add_segment(start_pos + Vector2(0, i))

func add_segment(pos):
	snake_data.append(pos)
	var SnakeSegment = snake_scene.instantiate()
	SnakeSegment.position - (pos * cell_size) + Vector2(0, cell_size)
	add_child(SnakeSegment)
	snake.append(SnakeSegment)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
