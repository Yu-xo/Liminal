extends CharacterBody2D


@export var speed := 100

@export var TurnBasedUI : Control


@onready var npc = get_tree().get_first_node_in_group("npc")

var direction
var can_interact : bool = true

var day : bool
var night : bool



func _physics_process(delta: float) -> void:

	turn_based_mode()
	Exploration_mode()
	if TimeCycle.has_shovel==true:
		print("shovel aquired")
	elif TimeCycle.has_basket==true:
		print("can use magic")
	elif TimeCycle.has_Water==true:
		print("can self heal now")



	
func turn_based_mode():
	if TimeCycle.Night == true:
		night = false
		day = true
		TurnBasedUI.visible = true
		
		
		
		
		

func Exploration_mode():
	if TimeCycle.Day == true:
		day = false
		night = true
		TurnBasedUI.visible = false
		direction = Input.get_vector("left","right","up","down")
		velocity  = direction * speed
		move_and_slide()



func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and day==false and can_interact==true:
		npc.interaction()
		print("interact")

		







func _on_interaction_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("npc"):
		can_interact = true


func _on_interaction_zone_area_exited(area: Area2D) -> void:
	if area.is_in_group("npc"):
		can_interact = false
