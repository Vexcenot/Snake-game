extends Node2D
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


func _process(delta: float) -> void:
	if Global.playMusic == true:
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
	if $Timer.time_left <= 100 and lowTime == false:
		$"BG music".volume_db = -80
		lowTime = true
		$"warning timer".play()
		


#func _on_bg_music_finished() -> void:
	#Global.playMusic = true


func _on_warning_timer_finished() -> void:
	Global.playMusic = true
	$"BG music".volume_db = 0
	
