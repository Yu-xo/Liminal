extends Node2D




@onready var start: Button = $Control/VBoxContainer/Start
@onready var exit: Button = $Control/VBoxContainer/Exit
@onready var credits: Button = $Control/VBoxContainer/Credits

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D



func _ready() -> void:
	audio_stream_player_2d.play()
	start.pressed.connect(_start_game)
	
	
func _start_game():
	get_tree().change_scene_to_file("res://Scenes/Levels/Start.tscn")

func _exit():
	get_tree().quit()
	
func credit():
	print("credits")
