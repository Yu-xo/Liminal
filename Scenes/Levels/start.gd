extends Node2D




func _ready() -> void:
	Dialogic.start("res://Scenes/Timelines/First_Entity.dtl")
	await Dialogic.timeline_ended
	get_tree().change_scene_to_file("res://Scenes/Levels/Shovel_leve.tscn")
