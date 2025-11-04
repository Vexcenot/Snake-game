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
		elif Global.music == "none":
			$"BG music".stop()

		$"BG music".play()
	if Global.paused:
		$"warning timer".stream_paused = true
		$"BG music".stream_paused = true
	else:
		$"warning timer".stream_paused = false
		$"BG music".stream_paused = false
		
	#WHEN ON LOW TIMER 
	if Global.timer <= 100 and Global.lowTime == false and Global.title == false:
		$"BG music".volume_db = -80
		Global.lowTime = true
		$"warning timer".play()
	if Global.timer <= 0:
		await get_tree().create_timer(1).timeout
		Global.timeUp = true
	$CanvasLayer/HBoxContainer/TIME/counter.text = str(int(Global.timer)).pad_zeros(3)
	$CanvasLayer/HBoxContainer/POINTS/counter.text = str(Global.score).pad_zeros(6)


func _on_warning_timer_finished() -> void:
	Global.playMusic = true
	$"BG music".volume_db = 0
