extends CharacterBody2D

@export var tail_segment_scene: PackedScene = preload("res://scenes/tail.tscn")
@onready var up: RayCast2D = $up
@onready var down: RayCast2D = $down
@onready var left: RayCast2D = $left
@onready var right: RayCast2D = $right
@onready var sprite: Sprite2D = $Sprite2D
var direction = Vector2.ZERO
var timer = 100
var original_original_original_time = 0.3
var original_original_time = original_original_original_time
var original_time = original_original_time
var final_time = original_time
var move_distance = 8
var turn_positions = []  # Stores turn positions and directions
var collision = false
var move_orders = []
var move_ready = false
var positions = []
var orientations = []  # Stores facing directions for tail
var turns = []  # Stores turns made
var length = 3
var tail_segments = []
var scanned = {"up": "", "down": "", "left": "", "right": ""}
var facing = "right"
var facing_prev = "right"
var movesame = false
var pending_tail_segment = false  # Flag to track pending tail additionz
var powerup = "current power up goes here"
var bigsnek = preload("res://sprite/big snake.png")
var smallsnek = preload("res://sprite/smol snake.png")
var collided = false
var snake_length = 2
var powered = false
var sprint = false
var player_input = true
var move_exit = false


func _ready():
	teleport_sequence()

func _process(delta):
	timer += delta
	time_reset()
	interact()
	update_sprite_orientation()
	move_current_scanner()
	sprinting()

func teleport_sequence():
	await get_tree().process_frame
	position.x -= 16
	for i in range(snake_length):
		positions.push_front(global_position)
		orientations.push_front(facing)
		spawn_tail_segment()
		position.x += move_distance
		positions.push_front(global_position)
		orientations.push_front(facing)
	move_ready = true

func final_tail():
	if tail_segments.size() > 0:
		var last = tail_segments[-1]
		var sprite = last.get_node("Sprite2D")
		sprite.frame = 0
		for i in tail_segments:
			if i != last:
				i.get_node("Sprite2D").frame = 1

		# Debug prints
		print("Final tail position:", last.global_position)
		print("Turn positions:", turn_positions)

func spawn_tail_segment():
	if tail_segment_scene:
		# Check if the last tail segment exists and has frame 4
		if tail_segments.size() > 0:
			var last_segment = tail_segments[-1]
			var last_sprite = last_segment.get_node("Sprite2D")
			if last_sprite and last_sprite.frame == 4:
				return  # Do not spawn a new segment if the last one is final

		# Spawn new tail segment
		var tail_segment = tail_segment_scene.instantiate()
		get_parent().add_child(tail_segment)
		tail_segment.global_position = global_position
		tail_segments.push_front(tail_segment)
		length += 1

		var sprite = tail_segment.get_node("Sprite2D")
		if sprite:
			await get_tree().create_timer(0.1).timeout

		# Ensure only the last tail segment is updated, without resetting previous turn frames
		update_tail_frames()


func update_tail_frames():
	if tail_segments.is_empty():
		return
	
	# Update the last tail segment only
	var last = tail_segments[-1]
	var sprite = last.get_node("Sprite2D")
	sprite.frame = 0  # Make sure the last segment is frame 0

	# Keep turn frames intact
	for i in range(tail_segments.size() - 1):
		var segment = tail_segments[i]
		var segment_sprite = segment.get_node("Sprite2D")
		for turn in turn_positions:
			if turn[0].distance_to(segment.global_position) < move_distance * 0.5:
				segment_sprite.frame = 3  # Maintain turn segments
				adjust_turn_frame(segment_sprite, turn[1], turn[2])
				break  # Stop checking once a turn is found


func time_reset():
	if timer >= final_time:

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
			lose_game()
			return
		position += direction * move_distance
		global_position_tracker()
		move_tail_segments()

		# Add tail segment only after moving
		if pending_tail_segment:
			spawn_tail_segment()
			pending_tail_segment = false  # Reset flag
		print(positions)

func global_position_tracker():
	positions.push_front(global_position)
	orientations.push_front(facing)
	if positions.size() > length:
		positions.pop_back()
		orientations.pop_back()

func move_tail_segments():
	for i in range(min(length - 1, tail_segments.size())):  # Include last tail segment
		if positions.size() > i + 1:
			tail_segments[i].global_position = positions[i + 1]
			update_tail_orientation(tail_segments[i], orientations[i + 1])
			check_turn_segment(tail_segments[i], positions[i + 1])


##################FIX THIS################
	# Move the last tail segment but also remove past turns it crosses
	if tail_segments.size() > 0:
		var last_index = tail_segments.size()
		if positions.size() > last_index:
			remove_past_turns(positions[last_index])  # Remove turns at this position

func remove_past_turns(last_tail_position):
	for i in range(turn_positions.size() - 1, -1, -1):  # Iterate in reverse to safely remove elements
		if turn_positions[i][0].distance_to(last_tail_position) < move_distance * 0.5:
			turn_positions.pop_at(i)  # Remove the turn position


func check_turn_segment(segment, position):
	var sprite = segment.get_node("Sprite2D")
	var is_last_segment = (segment == tail_segments[-1])  # Check if it's the last tail segment

	for turn in turn_positions:
		if turn[0].distance_to(position) < move_distance * 0.5:  # Check if segment is at a turn
			if is_last_segment:
				sprite.frame = 4  # Last segment gets frame 4
			else:
				sprite.frame = 3  # Regular turn segments get frame 3
			adjust_turn_frame(sprite, turn[1], turn[2])  # Pass previous and new facing directions
			return

	# Default behavior: last tail segment -> frame 0, others -> frame 1
	if is_last_segment:
		sprite.frame = 0
	else:
		sprite.frame = 1


func adjust_turn_frame(sprite: Sprite2D, prev_facing: String, new_facing: String):
	# Turning logic: prev_facing -> new_facing
	if prev_facing == "up" and new_facing == "right":  # Turning right from up
		sprite.flip_h = false
		sprite.rotation_degrees = 0
	elif prev_facing == "up" and new_facing == "left":  # Turning left from up
		sprite.flip_h = true
		sprite.rotation_degrees = 0
	elif prev_facing == "up" and new_facing == "down":  # Turning down from up
		sprite.flip_h = false
		sprite.rotation_degrees = 180
	elif prev_facing == "right" and new_facing == "up":  # Turning up from right
		sprite.flip_h = true
		sprite.rotation_degrees = 90
	elif prev_facing == "right" and new_facing == "down":  # Turning down from right
		sprite.flip_h = false
		sprite.rotation_degrees = 90
	elif prev_facing == "right" and new_facing == "left":  # Turning left from right
		sprite.flip_h = true
		sprite.rotation_degrees = 180
	elif prev_facing == "down" and new_facing == "right":  # Turning right from down
		sprite.flip_h = true
		sprite.rotation_degrees = 180
	elif prev_facing == "down" and new_facing == "left":  # Turning left from down
		sprite.flip_h = false
		sprite.rotation_degrees = 180
	elif prev_facing == "down" and new_facing == "up":  # Turning up from down
		sprite.flip_h = false
		sprite.rotation_degrees = 0
	elif prev_facing == "left" and new_facing == "up":  # Turning up from left
		sprite.flip_h = false
		sprite.rotation_degrees = -90
	elif prev_facing == "left" and new_facing == "down":  # Turning down from left
		sprite.flip_h = true
		sprite.rotation_degrees = -90
	elif prev_facing == "left" and new_facing == "right":  # Turning right from left
		sprite.flip_h = false
		sprite.rotation_degrees = 0
	elif prev_facing == "right" and new_facing == "up":  # Turning up from right
		sprite.flip_h = true
		sprite.rotation_degrees = 90

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
		pending_tail_segment = true  # Mark that we want to add a tail

#runs game over function and (should) clear out all datas
func lose_game():
	move_ready = false
	print("fuck")
	get_tree().paused = true
	original_time = 999999999
	print(final_time)

func move_current_scanner():
	var element1
	var element2
	if move_orders.size() > 0:
		element1 = move_orders[0]
	elif move_orders.size() > 1:
		element2 = move_orders[1]
	if element1 == element2:
		move_orders.clear

func facer():
	if move_orders.size() > 0:
		var next_move = move_orders.pop_front()
		if is_opposite_direction(next_move, facing):
			return
		if next_move != facing:  # Only store if an actual turn is made
			turn_positions.push_front([global_position, facing, next_move])  # Store both previous and new facing

		facing = next_move
		direction = {"up": Vector2.UP, "down": Vector2.DOWN, "left": Vector2.LEFT, "right": Vector2.RIGHT}[next_move]

	# Keep turn_positions one slot shorter than the snake length
	if turn_positions.size() >= length:
		turn_positions.pop_back()

#player inputs get added to a list to do list
func _input(event):
	var new_move = ""

	if event.is_action_pressed("k_up") and player_input == true:
		new_move = "up"
	elif event.is_action_pressed("k_down") and player_input == true:
		new_move = "down"
	elif event.is_action_pressed("k_left") and player_input == true:
		new_move = "left"
	elif event.is_action_pressed("k_right") and player_input == true:
		new_move = "right"

	# Ensure the new move is not a duplicate of the last move in the list
	if new_move != "" and (move_orders.is_empty() or move_orders.back() != new_move):
		move_orders.append(new_move)
	#speed up.

#debug
	if event.is_action_pressed("k_action2"):
		set_power("big")
		#update_all_textures(bigsnek)
	
#fix moving beyond death
func sprinting():
	if Input.is_action_pressed("k_shift"):
		final_time = original_time/3
		print("shat")
	else:
		final_time = original_time


#flashes between current power status and next one
#make it detect if touching mushroom.
func set_power(power: String):
	var current_power = Global.snake_status
	var blink_sec = 0.1
	$SmbPowerup.play()
	get_tree().paused = true
	original_time = 99999
	for i in range(4):
		Global.snake_status = current_power
		await get_tree().create_timer(blink_sec).timeout
		Global.snake_status = power
		await get_tree().create_timer(blink_sec).timeout  # Wait again before switching back
	original_time = original_original_time
	get_tree().paused = false
	powered = true


func update_sprite_orientation():
	update_tail_orientation(self, facing)


func _on_head_area_area_entered(area: Area2D) -> void:
	if area.name == "mushroom" and powered == false:
		set_power("big")
	if area.name == "winarea":
		win()
	if area.name == "endpost":
		win2()
	
	
#win conditions when touching flag pole. position pole in way that snake head will always be inside it. Make sure snake head doesnt by pass it.
#make flag seperate item that gets eten when snake touched top of flag pole
func win():
	player_input = false
	original_time = 999999999
	await get_tree().create_timer(0.5).timeout
	original_time = original_original_time
	if move_exit == true:
		move_orders.append("right")
	else:
		move_orders.append("down")

func win2():
	move_exit = true
	move_orders.append("right")
	
