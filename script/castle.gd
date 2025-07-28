extends Node2D


#func _on_entrance_area_entered(area: Area2D) -> void:
	#if area.name == "Head Area" and Global.winning == true:
		#$CastleEnd.visible = true
