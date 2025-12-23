extends Control


@export var Action_one : Button
@export var Action_two : Button
@export var Action_three : Button



func _ready() -> void:
	Action_one.pressed.connect(_on_action_one_pressed)

	
	
func _on_action_one_pressed():
	print("action one")
	TimeCycle._player_action = true
