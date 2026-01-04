extends Node2D

@export var destination: Marker2D
@export var cooldown_frames: int = 1

@onready var area_2d: Area2D = $Area2D

var can_teleport := true


func _ready():
	area_2d.body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if not can_teleport:
		return

	if body.is_in_group("player"):
		if destination == null:
			push_warning("[Teleporter] Destination Marker2D not assigned")
			return

		_disable_temporarily()

		# Instant relocation
		body.global_position = destination.global_position


func _disable_temporarily():
	can_teleport = false
	for i in cooldown_frames:
		await get_tree().process_frame
	can_teleport = true
