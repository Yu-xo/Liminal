extends Node2D

@export var Name : String
@export var item_held  : bool


@onready var detection_zone: Area2D = $Detection_Zone




func _ready() -> void:
	detection_zone.body_entered.connect(interaction)



func movement():
	pass
	
func interaction():
	if item_held==true:
		print("this npc have the Item!")
	else:
		print("no held item was held by this NPC")
		
