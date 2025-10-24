extends Node2D
var music : String = "none"
var store : String = ""
@export var trigger : bool = false
var overworld = preload("res://sounds/overworld.wav")
var underworld = preload("res://sounds/underworld.wav")
var invincible = preload("res://sounds/invinsibility muffled.wav")
var overworldFast = preload("res://sounds/fast overworld.wav")
var underworldFast = preload("res://sounds/fast underworld.wav")
var invincibleFast = preload("res://sounds/fast invincible.wav")
var lowTime = false


func _process(delta: float) -> void:
	if trigger == true:
		trigger = false
		if music == "overworld" or music == "none":
			if lowTime:
				$"BG music".stream = overworldFast
			else:
				$"BG music".stream = overworld
			store = music
		elif music == "underground":
			$"BG music".stream = overworld #change to under ground
			store = music
		elif music == "invincible":
			$"BG music".stream = invincible
			music = store

		$"BG music".play()
		
		
	#plays double time & mutes main audio
	if $Timer.time_left <= 5 and lowTime == false:
		$"BG music".volume_db = -80
		lowTime = true
		$"warning timer".play()
		


func _on_bg_music_finished() -> void:
	trigger = true


func _on_warning_timer_finished() -> void:
	trigger = true
	$"BG music".volume_db = 0
	
