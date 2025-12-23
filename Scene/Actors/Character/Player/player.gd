extends CharacterBody2D


@export var speed := 100

@export var TurnBasedUI : Control

var direction


var day : bool
var night : bool



func _physics_process(delta: float) -> void:

	turn_based_mode()
	Exploration_mode()




	
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
	if Input.is_action_just_pressed("interact") and day:
		print("interact")

		
	
