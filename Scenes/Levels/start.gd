extends Node2D


@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	Dialogic.start("res://Scenes/Timelines/First_Entity.dtl")
	await Dialogic.timeline_ended
	get_tree().change_scene_to_file("res://Scenes/Levels/Shovel_leve.tscn")
	audio_stream_player_2d.play()
