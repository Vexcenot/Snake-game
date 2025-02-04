extends CharacterBody2D

@export var speed = 200

var direction = Vector2.ZERO
var timer = 100
var move_distance = 8
var final_time = 0.1
var collision = false
var move_orders = []
var moveable = false
var positions = []
var orientations = []  # Stores facing directions for tail
var turns = []  # Stores turns made
var length = 3
var tail_segments = []
var scanned = {"up": "", "down": "", "left": "", "right": ""}
var facing = "right"
var facing_prev = "right"
var movesame = false
@export var tail_segment_scene: PackedScene = preload("res://scenes/spawntest.tscn")
@onready var up: RayCast2D = $up
@onready var down: RayCast2D = $down
@onready var left: RayCast2D = $left
@onready var right: RayCast2D = $right
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	teleport_sequence()

func _process(delta):
	timer += delta
	time_reset()
	interact()
	loose()
	update_sprite_orientation()
	#print("Facing:", facing)
	#print("Previous Facing:", facing_prev)
	#for turn in turns:
		#print("Turned from", turn[0], "to", turn[1])
	move_current_scanner()

func teleport_sequence():
	await get_tree().process_frame
	position.x -= 16
	for i in range(2):
		positions.push_front(global_position)
		orientations.push_front(facing)
		spawn_tail_segment()
		position.x += move_distance
		positions.push_front(global_position)
		orientations.push_front(facing)

func final_tail():
	if tail_segments.size() > 0:
		var last = tail_segments[-1]
		var sprite = last.get_node("Sprite2D")
		sprite.frame = 0
		last.modulate = Color.DARK_OLIVE_GREEN
		for i in tail_segments:
			if i != last:
				i.modulate = Color.WHITE
				i.get_node("Sprite2D").frame = 1

func spawn_tail_segment():
	if tail_segment_scene:
		var tail_segment = tail_segment_scene.instantiate()
		get_parent().add_child(tail_segment)
		tail_segment.global_position = global_position
		tail_segments.push_front(tail_segment)
		length += 1
		var sprite = tail_segment.get_node("Sprite2D")
		if sprite:
			sprite.modulate = Color(1, 1, 0)
			await get_tree().create_timer(0.1).timeout
			sprite.modulate = Color(1, 1, 1)
	final_tail()

func time_reset():
	if timer >= final_time:
		if facing != facing_prev:
			turns.append([facing_prev, facing])
		facing_prev = facing  # Save previous facing before updating
		facer()
		moving()
		timer = 0

func is_opposite_direction(new_move: String, current_facing: String) -> bool:
	return (new_move == "up" and current_facing == "down") or \
		(new_move == "down" and current_facing == "up") or \
		(new_move == "left" and current_facing == "right") or \
		(new_move == "right" and current_facing == "left")

func is_raycast_blocked(direction: String) -> bool:
	match direction:
		"up": return up.is_colliding() and up.get_collider() is StaticBody2D
		"down": return down.is_colliding() and down.get_collider() is StaticBody2D
		"left": return left.is_colliding() and left.get_collider() is StaticBody2D
		"right": return right.is_colliding() and right.get_collider() is StaticBody2D
		_: return false



func moving():
	if direction != Vector2.ZERO:
		if is_raycast_blocked(facing):
			return
		position += direction * move_distance
		global_position_tracker()
		move_tail_segments()

func global_position_tracker():
	positions.push_front(global_position)
	orientations.push_front(facing)
	if positions.size() > length:
		positions.pop_back()
		orientations.pop_back()

func move_tail_segments():
	for i in range(min(length - 1, tail_segments.size())):
		if positions.size() > i + 1:
			tail_segments[i].global_position = positions[i + 1]
			update_tail_orientation(tail_segments[i], orientations[i + 1])

func update_tail_orientation(segment, orientation):
	var sprite = segment.get_node("Sprite2D")
	match orientation:
		"left":
			sprite.flip_h = true
			sprite.rotation_degrees = 0
		"right":
			sprite.flip_h = false
			sprite.rotation_degrees = 0
		"up":
			sprite.flip_h = false
			sprite.rotation_degrees = -90
		"down":
			sprite.flip_h = false
			sprite.rotation_degrees = 90

func interact():
	if Input.is_action_just_pressed("k_action") and tail_segment_scene and positions.size() > 1:
		spawn_tail_segment()

func loose():
	if is_raycast_blocked(facing):
		pause_game()

func pause_game():
	print("Game paused due to collision with StaticBody2D.")
	get_tree().paused = true

func move_current_scanner():
	var element1
	var element2
	if move_orders.size() > 0:
		element1 = move_orders[0]
	elif move_orders.size() > 1:
		element2 = move_orders[1]
	if element1 == element2:
		move_orders.clear

#takes move orders and append it to the actual snake movement if all conditions are right
func facer():
	if move_orders.size() > 0:
		var next_move = move_orders.pop_front()
		if is_raycast_blocked(facing) and (is_opposite_direction(next_move, facing) or next_move == facing):
			pause_game()
			move_orders.clear()
			return
		if is_opposite_direction(next_move, facing):
			return
		facing = next_move
		direction = {"up": Vector2.UP, "down": Vector2.DOWN, "left": Vector2.LEFT, "right": Vector2.RIGHT}[next_move]
		if is_raycast_blocked(facing):
			pause_game()
		
#player inputs get added to a list to do list
func _input(event):
	if event.is_action_pressed("k_up") and move_orders.front() != "up":
		move_orders.append("up")
		print("up")
	elif event.is_action_pressed("k_down"):
		move_orders.append("down")
	elif event.is_action_pressed("k_left"):
		move_orders.append("left")
	elif event.is_action_pressed("k_right"):
		move_orders.append("right")

func update_sprite_orientation():
	update_tail_orientation(self, facing)
