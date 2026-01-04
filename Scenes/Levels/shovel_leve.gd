extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	Dialogic.start("res://Scenes/Timelines/shovel_timeline.dtl")
	await Dialogic.timeline_ended
	get_tree().change_scene_to_file("res://Scenes/Levels/Water_puzzle.tscn")
