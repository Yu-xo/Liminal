extends Node2D

@export var _name : String
@export var speed : int
@export var health : int
@export var dmg : int

@onready var player = get_tree().get_first_node_in_group("player")

var action : bool = true




var attack_pattern : Array = [
	1,
	2,
	3,
	4,
]


func _process(delta: float) -> void:
		if TimeCycle._player_action==true:
			Action_Decision()


func Action_Decision():
	attack_pattern.shuffle()
	var attack = attack_pattern[0]
	match attack:
		0:
			print("action1")
			TimeCycle._player_action = false
		1:
			print("action2")
			TimeCycle._player_action = false
		2:
			print("action3")
			TimeCycle._player_action = false
		3:
			print("action4")
			TimeCycle._player_action = false

	
	

	
func Action(name :String):
	print(name)
	
	
