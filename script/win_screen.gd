extends Control


func _ready() -> void:
	if Global.multiplayers:
		$"2p msg".visible = true
	else:
		$"1p msg".visible = true
