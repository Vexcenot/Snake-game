extends Control
var store : String = ""
@export var trigger : bool = false
var overworld : AudioStream = preload("res://sounds/overworld.wav")
var underworld : AudioStream = preload("res://sounds/underworld.wav")
var invincible : AudioStream = preload("res://sounds/invinsibility muffled.wav")
var overworldFast : AudioStream = preload("res://sounds/fast overworld.wav")
var underworldFast : AudioStream = preload("res://sounds/fast underworld.wav")
var invincibleFast : AudioStream = preload("res://sounds/fast invincible.wav")
var die : AudioStream = preload("res://sounds/Die.wav")
var undercoin : Texture2D = preload("res://sprite/under coin top ui.png")
var overcoin : Texture2D = preload("res://sprite/coin top ui.png")
var transcoin : Texture2D = preload("res://sprite/trans coin.png")
var flag : AudioStream = preload("res://sounds/win flag.wav")
var warning : AudioStream = preload("res://sounds/warning.wav")
var end : bool = false
var lowTime : bool = false


#pauses game
func _input(event):
	if event.is_action_pressed("esc") and Global.title == false:
		if Global.paused:
			unpause()
		else:
			pause()
	if event.is_action_pressed("click"):
		if soundHighlight:
			Global.soundToggle()
		if screenHighlight:
			Global.fullscreenToggle()
	if event.is_action_pressed("mute"):
		Global.soundToggle()

func pause():
	Global.muteMusic()
	get_tree().paused = true
	Global.paused = true
	Global.timeLive = false
	$"pause sound".play()

func unpause():
	Global.unmuteMusic()
	get_tree().paused = false
	Global.paused = false
	Global.timeLive = true
	$"pause sound".play()
#timer
func _process(delta: float) -> void:
	if Global.world_type == "transition":
		$CanvasLayer/HBoxContainer2/TIME/counter.visible = false
	else:
		$CanvasLayer/HBoxContainer2/TIME/counter.visible = true
	if Global.multiplayers:
		$CanvasLayer/HBoxContainer/POINTS/name.text = str("SNEKS")
	else:
		$CanvasLayer/HBoxContainer/POINTS/name.text = str("SNEK")
	if Global.resetCoinAnim:
		Global.resetCoinAnim = false
		$CanvasLayer/HBoxContainer2/COINS/AnimationPlayer.stop()
		$CanvasLayer/HBoxContainer2/COINS/AnimationPlayer.play("idle")
	if Global.world_type == "transition":
		$CanvasLayer/HBoxContainer2/COINS/CoinTopUi.texture = transcoin
		$"BG music".stop()
	elif Global.world_type == "underground":
		$CanvasLayer/HBoxContainer2/COINS/CoinTopUi.texture = undercoin
	else:
		$CanvasLayer/HBoxContainer2/COINS/CoinTopUi.texture = overcoin
	if Global.purgatory:
		$"BG music".volume_db = -80
	if Global.paused:
		$"warning timer".stream_paused = true
		$"BG music".stream_paused = true
	else:
		$"warning timer".stream_paused = false
		$"BG music".stream_paused = false
		
	#kills player when times up
	if Global.timer <= 0 and Global.winning == false and Global.timerDown == false:
		await get_tree().create_timer(1).timeout
		Global.timeUp = true
	$CanvasLayer/HBoxContainer2/TIME/counter.text = str(int(Global.timer)).pad_zeros(3)
	$CanvasLayer/HBoxContainer/POINTS/counter.text = str(Global.score).pad_zeros(6)
	$CanvasLayer/HBoxContainer2/COINS/HBoxContainer/counter.text = str(int(Global.coin)).pad_zeros(2)
	if Global.mute:
		$CanvasLayer2/sound.frame = 1
	else:
		$CanvasLayer2/sound.frame = 0
	if Global.title == false:
		if Global.mute == false:
			$CanvasLayer2/sound.hide()
		else:
			$CanvasLayer2/sound.show()
		$CanvasLayer2/fullscreen.hide()
	else:
		$CanvasLayer2/sound.show()
		$CanvasLayer2/fullscreen.show()

func _on_warning_timer_finished() -> void:
	Global.playMusic = true
	$"BG music".volume_db = 0

func _on_bg_music_finished() -> void:
	if lowTime and Global.winning == false:
		lowTime = false
		Global.playMusic = true
	#signals when music ends
	elif Global.winning:
		Global.winEnd = true

var screenHighlight = false
var soundHighlight = false




func _on_fullscreen_mouse_entered() -> void:
	screenHighlight = true
	print("shit")

func _on_fullscreen_mouse_exited() -> void:
	screenHighlight = false


func _on_sound_mouse_entered() -> void:
	soundHighlight = true


func _on_sound_mouse_exited() -> void:
	soundHighlight = false


func _on_button_pressed() -> void:
	Global.fullscreenToggle()


func _on_button_pressed2() -> void:
	Global.soundToggle()
	print("shit")
