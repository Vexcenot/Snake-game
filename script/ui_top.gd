extends Control
var store : String = ""
@export var trigger : bool = false
var overworld = preload("res://sounds/overworld.wav")
var underworld = preload("res://sounds/underworld.wav")
var invincible = preload("res://sounds/invinsibility muffled.wav")
var overworldFast = preload("res://sounds/fast overworld.wav")
var underworldFast = preload("res://sounds/fast underworld.wav")
var invincibleFast = preload("res://sounds/fast invincible.wav")
var die = preload("res://sounds/Die.wav")
var undercoin = preload("res://sprite/under coin top ui.png")
var overcoin = preload("res://sprite/coin top ui.png")
var transcoin = preload("res://sprite/trans coin.png")
var flag = preload("res://sounds/win flag.wav")
var warning = preload("res://sounds/warning.wav")
var end = false
var lowTime = false

#pauses game
func _input(event):
	if event.is_action_pressed("esc") and Global.title == false:
		if Global.paused:
			unpause()
		else:
			pause()

func pause():
	get_tree().paused = true
	Global.paused = true
	Global.timeLive = false
	$"pause sound".play()

func unpause():
	get_tree().paused = false
	Global.paused = false
	Global.timeLive = true
	$"pause sound".play()
#timer
func _process(delta: float) -> void:
	#if Global.timerDown and Global.timer > 0:
		#Global.timer -= 1
		#Global.score += 50
		#$"timer down".play()
	#if Global.timer == 0:
		#Global.timerDown = false
		#await get_tree().create_timer(2.36).timeout
		#
		#
		#get_tree().change_scene_to_file("res://scenes/win screen.tscn")
	if Global.resetCoinAnim:
		Global.resetCoinAnim = false
		$CanvasLayer/HBoxContainer/COINS/AnimationPlayer.stop()
		$CanvasLayer/HBoxContainer/COINS/AnimationPlayer.play("idle")
	if Global.world_type == "transition":
		$CanvasLayer/HBoxContainer/COINS/CoinTopUi.texture = transcoin
		$"BG music".stop()
	elif Global.world_type == "underground":
		$CanvasLayer/HBoxContainer/COINS/CoinTopUi.texture = undercoin
	else:
		$CanvasLayer/HBoxContainer/COINS/CoinTopUi.texture = overcoin
		
	if Global.purgatory:
		$"BG music".volume_db = -80
#music handler
	if Global.playMusic == true and Global.title == false:
		Global.playMusic = false
		if Global.music == "overworld":
			if Global.lowTime:
				$"BG music".stream = overworldFast
			else:
				$"BG music".stream = overworld
			store = Global.music
		elif Global.music == "underground":
			if Global.lowTime:
				$"BG music".stream = underworldFast
			else:
				$"BG music".stream = underworld
			store = Global.music
		elif Global.music == "invincible":
			$"BG music".stream = invincible
			Global.music = store
		elif Global.music == "die":
			$"BG music".stream = die
		elif Global.music == "flag":
			$"BG music".stream = flag
		elif Global.music == "none":
			$"BG music".stop()
		elif Global.music == "warning":
			$"BG music".stream = warning
			lowTime = true
			Global.music = store

		$"BG music".play()
	if Global.paused:
		$"warning timer".stream_paused = true
		$"BG music".stream_paused = true
	else:
		$"warning timer".stream_paused = false
		$"BG music".stream_paused = false
		
	#WHEN ON LOW TIMER 
	if Global.timer <= 100 and Global.lowTime == false and Global.title == false and Global.winning == false:
		#$"BG music".volume_db = -80
		Global.lowTime = true
		#$"warning timer".play()
		Global.music = "warning"
		Global.playMusic = true
	if Global.timer <= 0 and Global.winning == false and Global.timerDown == false:
		await get_tree().create_timer(1).timeout
		Global.timeUp = true
	$CanvasLayer/HBoxContainer/TIME/counter.text = str(int(Global.timer)).pad_zeros(3)
	$CanvasLayer/HBoxContainer/POINTS/counter.text = str(Global.score).pad_zeros(6)
	$CanvasLayer/HBoxContainer/COINS/HBoxContainer/counter.text = str(int(Global.coin)).pad_zeros(2)

func _on_warning_timer_finished() -> void:
	Global.playMusic = true
	$"BG music".volume_db = 0

func _on_bg_music_finished() -> void:
	if lowTime and Global.winning == false:
		lowTime = false
		Global.playMusic = true
	elif Global.winning:
		Global.winEnd = true
