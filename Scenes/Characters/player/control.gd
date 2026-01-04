extends Control

@onready var steps_label: Label = $VBoxContainer/StepsLabel
@onready var no_moves_label: Label =$VBoxContainer/NoMovesLabel
@onready var reset_button: Button = $VBoxContainer/Button

@onready var player := get_tree().get_first_node_in_group("player")


func _ready():
	no_moves_label.visible = false

	player.steps_changed.connect(_on_steps_changed)
	player.out_of_steps.connect(_on_out_of_steps)

	reset_button.pressed.connect(_on_reset_pressed)


func _on_steps_changed(current: int, max: int) -> void:
	steps_label.text = "Steps: %d / %d" % [current, max]
	no_moves_label.visible = false


func _on_out_of_steps() -> void:
	no_moves_label.visible = true


func _on_reset_pressed() -> void:
	get_tree().reload_current_scene()
