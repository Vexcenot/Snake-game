extends Control


func _ready() -> void:
	if Global.dead and Global.multiplayers :
		Global.purgatory = true
		visible = true
		await get_tree().process_frame
		Global.music = "none"
		$AudioStreamPlayer.play()
