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
	#print($Timer.time_left)
	#if Global.timeStart:
		#Global.timeStart = false
		#$Timer.start()
	#if Global.timeLive or Global.title == false:
		#$Timer.paused = false

#music handler
	if Global.playMusic == true and Global.title == false:
		Global.playMusic = false
		if Global.music == "overworld":
			if lowTime:
				$"BG music".stream = overworldFast
			else:
				$"BG music".stream = overworld
			store = Global.music
		elif Global.music == "underground":
			$"BG music".stream = underworld #change to under ground
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
		
	#plays double time & mutes main audio
	#if $Timer.time_left <= 100 and lowTime == false:
		#$"BG music".volume_db = -80
		#lowTime = true
		#$"warning timer".play()
	#if $Timer.time_left <= 0:
		#await get_tree().create_timer(1).timeout
		#Global.timeUp = true


func _on_warning_timer_finished() -> void:
	Global.timeLive = false
	Global.playMusic = true
	$"BG music".volume_db = 0
