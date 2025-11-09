extends CharacterBody2D
enum spawn_dir {right,down,left,up}
@export var tail_segment_scene: PackedScene = preload("res://scenes/tail2.tscn")
@export var fire_ball: PackedScene = preload("res://scenes/fire_ball.tscn")
@export var invArea: PackedScene = preload("res://scenes/invincible_frame.tscn")
@export var START_DIR : spawn_dir
@export var camera = true
@export var player2 = false
@onready var up: RayCast2D = $up
@onready var down: RayCast2D = $down
@onready var left: RayCast2D = $left
@onready var right: RayCast2D = $right
@onready var sprite: Sprite2D = $Sprite2D
var snake_speed = 0.3 #adjusts speed of snake I like 0.3
var snake_length = 2 + Global.bonus_length
var direction = Vector2.ZERO
var timer = 100
var final_time = Global.snake_speed
var move_distance = 16
var turn_positions = []  # Stores turn positions and directions
var eat_positions = []  # Stores eat positions and directions
var move_orders = []
var move_ready = false
var positions = []
var orientations = []  # Stores facing directions for tail
var length = 3
var tail_segments = []
var scanned = {"up": "", "down": "", "left": "", "right": ""}
var facing = "right"
var prev_move = "right"
var movesame = false
var pending_tail_segment = 0  # Flag to track pending tail additionz
var powerup = "current power up goes here"
var bigsnek = preload("res://sprite/big luigi.png")
var firesnek = preload("res://sprite/fire snake.png")
var smallsnek = preload("res://sprite/smol luigi.png")
var fireball = preload("res://scenes/fire_ball.tscn")
var collided = false
var sprint = false
var player_input = true
var move_exit = false
var under_block = 0
var under_under_block = false
var dead = false
var hurting = false
var turn_hurt = false
var ignore_turn = false
var timer_counter_toggle = false
var timer_counter = 0
var limit_move = "direction which snake cannot go"
var xLimit = "orientation the snake cant move in"
var fuck = false
var uninvincible = false
var invincible = false
var stopInsta = false
var powering = false
var cramp = false
var crap
var openJaw = 0
var eatAnim = false
var dontTurn = false
var move_direction = Vector2.ZERO
var next_move = "the next move the snake will make"
var weakening = false
var updateCam = 2


func _ready():
	if Global.multiplayers == false:
		queue_free()
	if Global.checkPointable:
		position.x = Global.spawnCoordx 
	$Camera/ColorRect.visible = true
	teleport_sequence()
	update_camera()
	await get_tree().create_timer(0.1).timeout
	$Camera/ColorRect.visible = false


func _process(delta):
	if Global.multiplayers == false:
		queue_free()
	#fixes off camera when pipe warping, but makes camera rubber bands
	if updateCam >= 0:
		$Camera.limit_left = Global.camera_limit 
		
	pausing()
	if move_orders.size() > 3:
		move_orders.pop_back()
		if move_orders[0] == move_orders[1]:
			move_orders.pop_front()

	timer += delta
	time_reset()
	update_sprite_orientation()
	sprinting()
	update_global_direction()
	check_collide()
	enter_entrance() 
	collision_updater()
	eat_animation()
	painful_turn()
	win2()
	dead_sprite()
	fucker()
	teleport()
	absolute_stop()
	if openJaw <= 0:
		openJaw = 0
	openMouth()


func pausing():
	if Global.paused == true:
		set_process_mode(PROCESS_MODE_INHERIT)

	else:
		set_process_mode(PROCESS_MODE_ALWAYS)



func _input(event):
	stopInsta = true
#move inputs
	if event.is_action_pressed("k_up") and player_input == true:
		#await get_tree().create_timer(0.1).timeout
		if under_block > 0:
			pass
		elif move_orders.size() > 0 and move_orders[0] != "down" or move_orders.size() == 0 and limit_move != "up" and xLimit != "vert" and under_block <= 0:
			xLimit = "vert"
			limit_move = "down"
			move_orders.append("up")
	elif event.is_action_pressed("k_down") and player_input == true and limit_move != "down" and xLimit != "vert":
		if move_orders.size() > 0 and move_orders[0] != "up" or move_orders.size() == 0:
			xLimit = "vert"
			limit_move = "up"
			move_orders.append("down")
	elif event.is_action_pressed("k_left") and player_input == true and limit_move != "left" and xLimit != "hori":
		if move_orders.size() > 0 and move_orders[0] != "right" or move_orders.size() == 0:
			xLimit = "hori"
			limit_move = "right"
			move_orders.append("left")
	elif event.is_action_pressed("k_right") and player_input == true and limit_move != "right" and xLimit != "hori":
		if move_orders.size() > 0 and move_orders[0] != "left" or move_orders.size() == 0:
			xLimit = "hori"
			limit_move = "left"
			move_orders.append("right")
#debug1
	if event.is_action_pressed("k_action") and player_input == true and Global.active_balls <= 1 and Global.snake_status == "fire2": 
		var fire_ball = fireball.instantiate()
		get_parent().add_child(fire_ball)
		if Global.direction == "right":
			fire_ball.global_position.x = position.x + 20
			fire_ball.global_position.y = position.y
		elif Global.direction == "left":
					fire_ball.global_position.x = position.x - 20
					fire_ball.global_position.y = position.y
		elif Global.direction == "up":
					fire_ball.global_position.x = position.x
					fire_ball.global_position.y = position.y - 20
		elif Global.direction == "down":
					fire_ball.global_position.x = position.x
					fire_ball.global_position.y = position.y + 13



#debug2
	if event.is_action_pressed("k_action2"):
		Global.reset()
	if event.is_action_released("k_action2"):
		fuck = false
func painful_turn():
	if ignore_turn and Global.snake_status != "small":
		sprite.frame = 9

func fucker():
	if fuck:
		move_orders.append("right")
			
	#gives snake length on start
func teleport_sequence():
	if START_DIR == spawn_dir.right:
		limit_move = "left"
		Global.direction = "right"
		await get_tree().process_frame
		position.x -= move_distance*snake_length
		for i in range(snake_length):
			spawn_tail_segment()
			position.x += move_distance
			positions.push_front(global_position)
			orientations.push_front(facing)
	elif START_DIR == spawn_dir.down:
		facing = "down"
		limit_move = "up"
		Global.direction = "down"
		await get_tree().process_frame
		position.y -= move_distance*snake_length
		for i in range(snake_length):
			spawn_tail_segment()
			position.y += move_distance
			positions.push_front(global_position)
			orientations.push_front(facing)
		move_orders.append("down")
	move_ready = true

#processes adding length to snake mid-game
func eat(): 
	if Global.eatable >= 1:
		Global.eatable -= 1
		Global.bonus_length += 1
		eatAnim = true
		pending_tail_segment += 1
		eat_positions.push_front(global_position) #adds "full" sprite to tail.

#function that spawns tails
func spawn_tail_segment():
	if tail_segment_scene:
		# Spawn new tail segment
		var tail_segment = tail_segment_scene.instantiate()
		get_parent().add_child(tail_segment)
		tail_segment.global_position = global_position
		# Make the segment initially invisible
		tail_segment.modulate.a = 0
		tail_segments.push_front(tail_segment)
		length += 1
	# Update the last tail segment only
	var last = tail_segments[-1]
	var tail_tip = last.get_node("Sprite2D")
	if move_ready == false:
		tail_tip.frame = 0

#tick rate system
var eatAnim2 = false
func time_reset():
	if timer >= final_time:
		updateCam -= 1
		cramp = false
		$Camera.limit_left = Global.camera_limit
		# Make all tail segments visible
		for segment in tail_segments:
			segment.modulate.a = 1
		prev_move = facing  # Save previous facing before updating
		eat()
		move()
		
		timer = 0
		if timer_counter_toggle == true:
			timer_counter += 1
		if timer_counter >= 2:
			ignore_turn = false
			timer_counter_toggle = false
			timer_counter = 0
			if sprite.frame == 9:
				sprite.frame = 2
		if eatAnim:
			eatAnim2 = true
			sprite.frame = 2
		if eatAnim2 == true:
			eatAnim2 = false
			eatAnim = false
		if uninvincible:
			uninvincible = false
			invincible = false
			
			

func is_raycast_blocked(snake_facing: String) -> bool:
	match snake_facing:
		"up": return up.is_colliding() and up.get_collider() is StaticBody2D
		"down": return down.is_colliding() and down.get_collider() is StaticBody2D
		"left": return left.is_colliding() and left.get_collider() is StaticBody2D
		"right": return right.is_colliding() and right.get_collider() is StaticBody2D
		_: return false

func global_position_tracker():
	positions.push_front(global_position)
	orientations.push_front(facing)
	if positions.size() > length:
		positions.pop_back()
		orientations.pop_back()

func move_tail_segments():
	for i in range(min(length, tail_segments.size())):
		if positions.size() > i + 1:
			tail_segments[i].global_position = positions[i + 1]
			update_tail_orientation(tail_segments[i], orientations[i + 1])
			check_turn_segment(tail_segments[i], positions[i + 1])
			check_eat_segment(tail_segments[i], positions[i + 1])

	# Remove past eat positions when the last tail segment passes them
	if tail_segments.size() > 0:
		var last_index = tail_segments.size()
		if positions.size() > last_index:
			remove_past_turns(positions[last_index])
			remove_past_eats(positions[last_index])

func check_eat_segment(segment, eat_coords):
	var full_sprite = segment.get_node("Sprite2D")
	for eat_pos in eat_positions:
		if eat_pos.distance_to(eat_coords) < move_distance * 0.5:
			# Only show eating animation if it's not the last segment
			if segment != tail_segments[-1]:
				full_sprite.frame = 7
			return

func remove_past_eats(last_tail_position):
	for i in range(eat_positions.size() - 1, -1, -1):
		if eat_positions[i].distance_to(last_tail_position) < move_distance * 0.5:
			eat_positions.pop_at(i)
			
func remove_past_turns(last_tail_position):
	for i in range(turn_positions.size() - 1, -1, -1):  # Iterate in reverse to safely remove elements
		if turn_positions[i][0].distance_to(last_tail_position) < move_distance * 0.5 and pending_tail_segment == 0:
			turn_positions.pop_at(i)  # Remove the turn position

func adjust_turn_frame(turn_sprite: Sprite2D, prev_facing: String, new_facing: String):
	# Turning logic: prev_facing -> new_facing
	if prev_facing == "up" and new_facing == "right" :  # Turning right from up
		turn_sprite.flip_h = false
		turn_sprite.rotation_degrees = 0
	elif prev_facing == "up" and new_facing == "left":  # Turning left from up
		turn_sprite.flip_h = true
		turn_sprite.rotation_degrees = 0
	elif prev_facing == "up" and new_facing == "down":  # Turning down from up
		turn_sprite.flip_h = false
		turn_sprite.rotation_degrees = 180
	elif prev_facing == "right" and new_facing == "up":  # Turning up from right
		turn_sprite.flip_h = true
		turn_sprite.rotation_degrees = 90
	elif prev_facing == "right" and new_facing == "down":  # Turning down from right
		turn_sprite.flip_h = false
		turn_sprite.rotation_degrees = 90
	elif prev_facing == "right" and new_facing == "left":  # Turning left from right
		turn_sprite.flip_h = true
		turn_sprite.rotation_degrees = 180
	elif prev_facing == "down" and new_facing == "right":  # Turning right from down
		turn_sprite.flip_h = true
		turn_sprite.rotation_degrees = 180
	elif prev_facing == "down" and new_facing == "left":  # Turning left from down
		turn_sprite.flip_h = false
		turn_sprite.rotation_degrees = 180
	elif prev_facing == "down" and new_facing == "up":  # Turning up from down
		turn_sprite.flip_h = false
		turn_sprite.rotation_degrees = 0
	elif prev_facing == "left" and new_facing == "up":  # Turning up from left
		turn_sprite.flip_h = false
		turn_sprite.rotation_degrees = -90
	elif prev_facing == "left" and new_facing == "down":  # Turning down from left
		turn_sprite.flip_h = true
		turn_sprite.rotation_degrees = -90
	elif prev_facing == "left" and new_facing == "right":  # Turning right from left
		turn_sprite.flip_h = false
		turn_sprite.rotation_degrees = 0
	elif prev_facing == "right" and new_facing == "up":  # Turning up from right
		turn_sprite.flip_h = true
		turn_sprite.rotation_degrees = 90
	elif prev_facing == "down" and new_facing == "down":  # Turning up from right
		turn_sprite.flip_h = false
		turn_sprite.rotation_degrees = 90

func update_tail_orientation(segment, orientation):
	var turn_sprite = segment.get_node("Sprite2D")
	match orientation:
		"left":
			turn_sprite.flip_h = true
			turn_sprite.rotation_degrees = 0
		"right":
			turn_sprite.flip_h = false
			turn_sprite.rotation_degrees = 0
		"up":
			turn_sprite.flip_h = false
			turn_sprite.rotation_degrees = -90
		"down":
			turn_sprite.flip_h = false
			turn_sprite.rotation_degrees = 90

func interact():
	if Input.is_action_just_pressed("k_action") and tail_segment_scene and positions.size() > 1:
		eat()
		# Record the position where we're adding a new tail segment
		eat_positions.push_front(global_position)
	
#pain happens here
#runs game over function and (should) clear out all datas
func hurt():

	if Global.invincible == false and under_block <= 0:
		if Global.snake_status != "small":
			lose_power()
		else:
			die()

func lose_power():
	weakening = true
	invincible = true
	Global.invincible = true
	#invinciblity_blink()
	Global.snake_status = "big"
	var blink_sec = 0.1
	var current_power = Global.snake_status
	if ignore_turn:
		sprite.frame = 9
	$Powerdn.play()
	get_tree().paused = true
	pause_move()
	for i in range(5):
		Global.snake_status = current_power
		await get_tree().create_timer(blink_sec).timeout
		Global.snake_status = "small"
		await get_tree().create_timer(blink_sec).timeout
	resume_move()
	timer = 0
	if Global.paused == false:
		get_tree().paused = false
	await get_tree().create_timer(2).timeout
	invincible = false
	Global.invincible = false
	weakening = true
	
	
#snake pass through blocks when smalln't
func collision_updater():
	if Global.snake_status != "small":
		$up.set_collision_mask_value(2, true)
		$down.set_collision_mask_value(2, true)
		$left.set_collision_mask_value(2, true)
		$right.set_collision_mask_value(2, true)
		$up.set_collision_mask_value(1, false)
		$down.set_collision_mask_value(1, false)
		$left.set_collision_mask_value(1, false)
		$right.set_collision_mask_value(1, false)
	else:
		$up.set_collision_mask_value(2, false)
		$down.set_collision_mask_value(2, false)
		$left.set_collision_mask_value(2, false)
		$right.set_collision_mask_value(2, false)
		$up.set_collision_mask_value(1, true)
		$down.set_collision_mask_value(1, true)
		$left.set_collision_mask_value(1, true)
		$right.set_collision_mask_value(1, true)



#makes tails check if there's a turn
func check_turn_segment(segment, turn_coord):
	var tail_sprite = segment.get_node("Sprite2D")
	var is_last_segment = (segment == tail_segments[-1])  # Check if it's the last tail segment
	for turn in turn_positions:
		if turn[0].distance_to(turn_coord) < move_distance * 0.5:  # Check if segment is at a turn
			if is_last_segment: #turn sprite
				tail_sprite.frame = 4  # Last segment gets frame 4
			else:
				tail_sprite.frame = 3  # Regular turn segments get frame 3
			adjust_turn_frame(tail_sprite, turn[1], turn[2])  # Pass previous and new facing directions
			return
	# Default behavior: last tail segment -> frame 0, others -> frame 1
	if is_last_segment:
		tail_sprite.frame = 0
	else:
		tail_sprite.frame = 1

func set_firepower(): 
	powering = true
	Global.eatable += 1
	var current_power = Global.snake_status
	var blink_sec = 0.1
	if Global.snake_status != "fire2":
		$Powerup.play()
		get_tree().paused = true
		pause_move()
		Global.snake_status = "fire"
		await get_tree().create_timer(1).timeout
		Global.snake_status = "fire2"
		resume_move()
		timer = 0
		if Global.paused == false:
			get_tree().paused = false

	powering = false

func set_power(power: String):
	powering = true
	Global.eatable += 1
	var current_power = Global.snake_status
	var blink_sec = 0.1
	if Global.snake_status == "small":
		$Powerup.play()
		get_tree().paused = true
		pause_move()
		for i in range(4):
			Global.snake_status = current_power
			await get_tree().create_timer(blink_sec).timeout
			Global.snake_status = power
			await get_tree().create_timer(blink_sec).timeout  # Wait again before switching back
		under_block = 0
		resume_move()
		timer = 0
		if Global.paused == false:
			get_tree().paused = false

	powering = false
	
func dead_sprite():
	if dead:
		sprite.frame = 6

func absolute_stop():
	if move_ready == false:
		pause_move()
		final_time == 99999

func die():
	if Global.winning == false:
		if Global.checkPointable2:
			Global.checkPointable = true
		Global.invincible = false
		Global.music = "die"
		Global.playMusic = true
		Global.dead = true
		dead = true
		move_ready = false
		get_tree().paused = true
		pause_move()
		sprite.frame = 6
		var delay_between_segments = 0.05  # 50ms delay between segments
		var all_segments = [self] + tail_segments  # Head first, then tail segments
			# First, play the head's death animation
		await get_tree().create_timer(0.18).timeout
		$AnimationPlayer.play("die")
		await get_tree().create_timer(delay_between_segments).timeout  # Initial delay for head
			# Start from index 1 since we already animated the head
		for i in range(1, all_segments.size()):
			var segment = all_segments[i]
			if segment.has_node("AnimationPlayer"):
				var anim_player = segment.get_node("AnimationPlayer")
				anim_player.play("die")
				# Wait before playing the next segment's animation
			if i < all_segments.size() - 1:  # Don't wait after the last segment
				await get_tree().create_timer(delay_between_segments).timeout
		await get_tree().create_timer(3).timeout
		Global.reset()
		Global.die()

func update_global_direction():
	if not move_orders.is_empty():
		Global.direction = move_orders[0]

var collide_up = false
var collide_down = false
var collide_left = false
var collide_right = false
func check_collide():
	if hurting and up.is_colliding() and up.get_collider() is StaticBody2D:
		collide_up = true
	else:
		collide_up = false
	if hurting and down.is_colliding() and down.get_collider() is StaticBody2D:
		collide_down = true
	else:
		collide_down = false
	if hurting and right.is_colliding() and right.get_collider() is StaticBody2D:
		collide_right = true
	else:
		collide_right = false
	if hurting and left.is_colliding() and right.get_collider() is StaticBody2D:
		collide_left = true
	else:
		collide_left = false


#prevents turn sprite for a single turn
func ignoring_turning():
	if Global.invincible:
		die()
	else:
		ignore_turn = true
		timer_counter_toggle = true



#vroom.
func sprinting():
	if move_ready == true:
		if Input.is_action_pressed("k_shift"):
			stopInsta = true
			#final_time = Global.snake_speed*0.3
			final_time = 0.02
		else:
			final_time = Global.snake_speed


func update_sprite_orientation():
	if ignore_turn == false:
		update_tail_orientation(self, facing)


func starEat():
	var Inv = invArea.instantiate()
	get_parent().add_child(Inv)
	Inv.global_position = global_position
	pending_tail_segment += 1


#how snake when touch different areas.
var aah = 0
func _on_head_area_area_entered(area: Area2D) -> void:
	if area.name == "mushroom":
		set_power("big")
	if area.name == "1up":
		eat()#change this to custom 1up code
	if area.name == "star":
		starEat()
	if area.name == "flower": #add proper power up trans
		if Global.snake_status == "small":
			set_power("big")
		else:
			set_firepower()
	if area.name == "winarea" and Global.winning == false:
		win()
	if area.name == "endpost":
		move_exit = true
	if area.name == "enemy" and Global.snake_status == "small":
		await get_tree().create_timer(0.1).timeout
		if powering == false:
			hurt()
	if area.name == "enemyKoopa" and Global.snake_status == "small" and Global.direction != "down":
		await get_tree().create_timer(0.1).timeout
		if powering == false:
			hurt()
	if area.name == "edible":
		openJaw += 1
	if area.name == "edible2" and Global.snake_status != "small":
		openJaw += 1
	if area.name == "block_area2" and Global.snake_status == "small":
		under_block += 1 #make this count up and down insteadd
	if area.name == "block_area":
		under_block += 1
	if area.name == "oob" and Global.winning == false and invincible == false:
		die()
	if area.name == "brick_area" and Global.snake_status != "small":
		Global.eatable += 1
	if area.name == "enemy" and Global.snake_status != "small":
		Global.eatable += 1
	if area.name == "coin_area":
		Global.eatable += 1
	if area.name == "shell" and Global.snake_status != "small":
		Global.eatable += 1
	if area.name == "flag":
		Global.eatable += 1
	if area.name == "pipe_enter":
		move_orders.clear()
		player_input = false
		invincible = true
		Global.checkPointable = false
	if area.name == "GOUP":
		move_orders.append("up")
	if area.name == "super_eat":
		Global.eatable += 1


func teleport():
	if Global.teleport_all:
		position.x = Global.teleport_x
		position.y = Global.teleport_y

func enter_entrance():
	if Global.entranceStopper == false:
		crap = position.x + 135
	elif camera == true:
		$Camera.limit_right = crap 


func eat_animation():
	if eatAnim:
		sprite.frame = 5


func openMouth():
	if dead == false and openJaw == 0:
		sprite.frame = 2
	elif openJaw >= 1 and dead == false:
		sprite.frame = 5


#when leaving area.
func _on_head_area_area_exited(area: Area2D) -> void:
	if area.name == "edible":
		openJaw -= 1
	if area.name == "edible2" and Global.snake_status != "small":
		openJaw -= 1
	if area.name == "block_area2" and Global.snake_status == "small":
		under_block -= 1
	if area.name == "block_area":
		under_block -= 1
	if area.name == "endpost":
		move_exit = false
	if area.name == "entrance" and Global.winning == true or area.name == "pipe_enter":
		position.y = 9999
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://scenes/win screen.tscn")
	if area.name == "pipe_enter":
		await get_tree().create_timer(1).timeout
		invincible = false
		


#block bumping animation
func hit_block():
		sprite.frame = 8
		pause_move()
		await get_tree().create_timer(0.2).timeout
		sprite.frame = 2
		await get_tree().create_timer(0.2).timeout
		resume_move()


func pause_move():
	invincible = true
	hurting = true
	move_ready = false
	timer = 0
	final_time = 9999
	
	
func resume_move():
	hurting = false
	move_ready = true
	final_time = Global.snake_speed
	invincible = false

#win conditions when touching flag pole. position pole in way that snake head will always be inside it & snake head doesnt by pass it.
func win():
	move_orders.clear()
	Global.winning = true
	player_input = false
	xLimit = "none"
	limit_move = "none"
	pause_move()
	await get_tree().create_timer(0.5).timeout
	resume_move()
	if move_exit == true:
		move_exit2 = true
	else:
		move_orders.append("down")
		Global.direction = "down"
		move_exit2 = true
	await get_tree().create_timer(5).timeout
#second part of win animation
var 	move_exit2 = false
func win2():
	if move_exit and move_exit2:
		move_exit2 = false
		if Global.direction == "left":
			move_orders.clear()
			move_orders.append("down")
			move_orders.append("right")
		else:
			move_orders.append("right")
			move_orders.append("down")
			move_orders.append("right")


func update_camera():
	if camera == false:
		$Camera.enabled = false


func move():
	Global.snakePosX = global_position.x
	if move_orders.size() > 0: #make it also check if snake is paused and that next move wouldnt run into itself.
		if move_orders[0] == next_move or move_orders[0] == limit_move or move_orders[0] == "up" and under_block > 0:
			move_orders.pop_front()
		else:
			next_move = move_orders.pop_front()
		#checks turns
		if next_move == "up" and up.is_colliding() and up.get_collider() is StaticBody2D:
			ignoring_turning()
		elif next_move == "down" and down.is_colliding() and down.get_collider() is StaticBody2D:
			ignoring_turning()
		elif next_move == "right" and right.is_colliding() and right.get_collider() is StaticBody2D:
			ignoring_turning()
		elif next_move == "left" and left.is_colliding() and left.get_collider() is StaticBody2D:
			ignoring_turning()


#move calculate
		if next_move != facing and ignore_turn == false and next_move != "null": 
			turn_positions.push_front([global_position, facing, next_move])  # Store both previous and new facing
			  # Store both previous and new facing
		facing = next_move
		move_direction = {"up": Vector2.UP, "down": Vector2.DOWN, "left": Vector2.LEFT, "right": Vector2.RIGHT}[next_move]
	# Keep turn_positions one slot shorter than the snake length
	if turn_positions.size() >= length:
		turn_positions.pop_back()
		#runs hurt mechanic if facing is the same as raycast


#real moves
	if move_direction != Vector2.ZERO:
#LOOK INTO THIS!!!!!!!!
		if is_raycast_blocked(facing):
			if not hurting:
				hurt()
		else:
			position += move_direction * move_distance
			global_position_tracker()
			move_tail_segments()

		# Add tail segment only after moving
		if pending_tail_segment >= 1:
			pending_tail_segment -= 1
			spawn_tail_segment()
