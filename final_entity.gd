extends Node2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	Dialogic.start("res://Scenes/Timelines/final_entity_timeline.dtl")
	audio_stream_player_2d.play()
