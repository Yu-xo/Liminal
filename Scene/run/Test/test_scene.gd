extends Node2D



@onready var time_cycle: Label = $TimeCycle


func _physics_process(delta: float) -> void:
	if TimeCycle.Day == true:
		time_cycle.text = "Day"
	elif TimeCycle.Night == true:
		time_cycle.text  = "Night"
