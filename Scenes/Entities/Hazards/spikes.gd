extends Area2D
class_name Spikes

@export var start_up: bool = true

# Tween punch tuning
@export var punch_scale: float = 1.25
@export var punch_duration: float = 0.06

var is_up: bool
var is_covered: bool = false

var punch_tween: Tween = null

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D


func _ready():
	is_up = start_up
	_apply_state(true)

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	var player := get_tree().get_first_node_in_group("player")
	if player:
		player.steps_changed.connect(_on_player_step)


func _on_player_step(_current: int, _max: int) -> void:
	is_up = not is_up
	_apply_state(false)


# -------------------------
# VISUAL STATE (ANIM + TWEEN)
# -------------------------
func _apply_state(immediate: bool) -> void:
	# Kill previous punch tween safely
	if punch_tween and punch_tween.is_valid():
		punch_tween.kill()
		punch_tween = null

	var anim_name := "on" if is_up else "off"

	# Force animation pose instantly (no delay)
	anim.play(anim_name)
	anim.seek(0.0, true)

	if immediate:
		return

	# Create new punch tween
	punch_tween = create_tween()
	punch_tween.set_trans(Tween.TRANS_BACK)
	punch_tween.set_ease(Tween.EASE_OUT)

	punch_tween.tween_property(
		sprite,
		"scale",
		Vector2.ONE * punch_scale,
		punch_duration
	)

	punch_tween.tween_property(
		sprite,
		"scale",
		Vector2.ONE,
		punch_duration * 0.6
	)


# -------------------------
# COLLISION LOGIC
# -------------------------
func _on_body_entered(body):
	if body is Pushable:
		is_covered = true
		return

	if body.is_in_group("player") and is_up and not is_covered:
		get_tree().reload_current_scene()


func _on_body_exited(body):
	if body is Pushable:
		is_covered = false
