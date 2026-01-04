extends Node2D

@export var sprite_2d :Sprite2D

# -------------------------
# BREATHING TUNING
# -------------------------
@export var breathe_scale: float = 0.05
@export var breathe_height: float = 2.0
@export var breathe_duration: float = 1.6

var breathe_tween: Tween

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	_start_breathing()
	audio_stream_player_2d.play()

func _start_breathing():
	# Kill old tween if re-entered
	if breathe_tween and breathe_tween.is_valid():
		breathe_tween.kill()

	breathe_tween = create_tween()
	breathe_tween.set_loops()
	breathe_tween.set_trans(Tween.TRANS_SINE)
	breathe_tween.set_ease(Tween.EASE_IN_OUT)

	# Inhale
	breathe_tween.tween_property(
		sprite_2d,
		"scale",
		Vector2(1.0 + breathe_scale, 1.0 + breathe_scale),
		breathe_duration * 0.5
	)

	breathe_tween.parallel().tween_property(
		sprite_2d,
		"position:y",
		sprite_2d.position.y - breathe_height,
		breathe_duration * 0.5
	)

	# Exhale
	breathe_tween.tween_property(
		sprite_2d,
		"scale",
		Vector2.ONE,
		breathe_duration * 0.5
	)

	breathe_tween.parallel().tween_property(
		sprite_2d,
		"position:y",
		sprite_2d.position.y,
		breathe_duration * 0.5
	)


func _stop_breathing():
	if breathe_tween and breathe_tween.is_valid():
		breathe_tween.kill()
		breathe_tween = null

	sprite_2d.scale = Vector2.ONE


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_stop_breathing()

		Dialogic.start("res://Scenes/Timelines/water_timeline.dtl")
		await Dialogic.timeline_ended

		get_tree().change_scene_to_file("res://Scenes/Levels/crown_puzzle.tscn")
