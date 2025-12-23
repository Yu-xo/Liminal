extends Control


@export var day : Button
@export var night : Button

func _ready() -> void:
	day.pressed.connect(_on_day_)
	night.pressed.connect(_on_night_)
	
	
func _on_day_():
	print("day is on ! [] night is off")
	TimeCycle.Day = true 
	TimeCycle.Night = false


func _on_night_():
	print("night is on ! [] day is off")
	TimeCycle.Night = true
	TimeCycle.Day = false
