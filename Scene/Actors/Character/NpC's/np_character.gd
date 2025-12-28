extends Node2D

@export var Name : String
@export var item_held  : bool


@onready var detection_zone: Area2D = $Detection_Zone


func _physics_process(delta: float) -> void:
	movement()

func _ready() -> void:
	detection_zone.body_entered.connect(interaction)



func movement():
	pass
	
func interaction():
	Dialogic.start("RuruTimeLine")

		
