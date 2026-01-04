extends CharacterBody2D

@onready var detection_zone: Area2D = $detection_zone
@onready var sprite: Node2D = $Sprite2D

# -------------------------
# GRID CONFIG
# -------------------------
@export var cell_size: Vector2i = Vector2i(22, 22)
@export var move_duration: float = 0.18

# -------------------------
# STEP SYSTEM
# -------------------------
@export var min_steps: int = 0
@export var max_steps: int = 20
var current_steps: int = 0

# -------------------------
# ANIMATION TUNING
# -------------------------
@export var squash_strength: float = 0.18
@export var squash_duration: float = 0.08

@export var idle_wiggle_scale: float = 0.04
@export var idle_wiggle_speed: float = 2.5

# -------------------------
# RAYCASTS (ORDER MATTERS)
# [Right, Left, Down, Up]
# -------------------------
@export var move_rays: Array[RayCast2D]

# -------------------------
# INTERNAL STATE
# -------------------------
var is_moving: bool = false
var idle_time: float = 0.0


func _physics_process(delta: float) -> void:
	if is_moving:
		return

	handle_grid_input()
	idle_wiggle(delta)


func handle_grid_input() -> void:
	if current_steps >= max_steps:
		return

	var dir := Vector2.ZERO
	var ray: RayCast2D = null

	if Input.is_action_just_pressed("right"):
		dir = Vector2.RIGHT
		ray = move_rays[0]
	elif Input.is_action_just_pressed("left"):
		dir = Vector2.LEFT
		ray = move_rays[1]
	elif Input.is_action_just_pressed("down"):
		dir = Vector2.DOWN
		ray = move_rays[2]
	elif Input.is_action_just_pressed("up"):
		dir = Vector2.UP
		ray = move_rays[3]

	if dir == Vector2.ZERO:
		return

	ray.force_raycast_update()
	if ray.is_colliding():
		return

	move_one_cell(dir)


func move_one_cell(direction: Vector2) -> void:
	is_moving = true
	idle_time = 0.0

	var start_pos := global_position
	var target_pos := global_position + Vector2(
		direction.x * cell_size.x,
		direction.y * cell_size.y
	)

	var move_tween := create_tween()
	move_tween.set_trans(Tween.TRANS_SINE)
	move_tween.set_ease(Tween.EASE_IN_OUT)

	# Movement
	move_tween.tween_property(
		self,
		"global_position",
		target_pos,
		move_duration
	)

	# Squash & stretch
	var squash := Vector2.ONE
	if abs(direction.x) > 0:
		squash = Vector2(1.0 + squash_strength, 1.0 - squash_strength)
	else:
		squash = Vector2(1.0 - squash_strength, 1.0 + squash_strength)

	move_tween.parallel().tween_property(
		sprite,
		"scale",
		squash,
		squash_duration
	)

	move_tween.tween_property(
		sprite,
		"scale",
		Vector2.ONE,
		squash_duration
	)

	await move_tween.finished

	current_steps += 1
	current_steps = clamp(current_steps, min_steps, max_steps)

	is_moving = false


func idle_wiggle(delta: float) -> void:
	if is_moving:
		return

	idle_time += delta * idle_wiggle_speed
	var wiggle := sin(idle_time) * idle_wiggle_scale
	sprite.scale = Vector2.ONE + Vector2(wiggle, -wiggle)
