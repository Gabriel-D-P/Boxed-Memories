extends Node2D


func _pressed(movile: bool) -> void:
	Global.mobile = movile
	get_tree().change_scene_to_file("res://Nodes/menu.tscn")
