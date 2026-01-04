extends CharacterBody2D

signal steps_changed(current: int, max: int)
signal out_of_steps

@onready var detection_zone: Area2D = $detection_zone
@onready var sprite: Node2D = $Sprite2D

# -------------------------
# DEBUG
# -------------------------
@export var debug_enabled: bool = true

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
# RAYCASTS
# [Right, Left, Down, Up]
# -------------------------
@export var move_rays: Array[RayCast2D]

# -------------------------
# INTERNAL STATE
# -------------------------
var is_moving := false
var idle_time := 0.0


func _ready():
	add_to_group("player")

	if debug_enabled:
		print("[PLAYER] Ready | Steps:", current_steps, "/", max_steps)

	emit_signal("steps_changed", current_steps, max_steps)


func _physics_process(delta: float) -> void:
	if is_moving:
		return

	handle_grid_input()
	idle_wiggle(delta)


# -------------------------
# STEP API
# -------------------------
func can_move() -> bool:
	return current_steps < max_steps


func get_steps_left() -> int:
	return max_steps - current_steps


func reset_steps() -> void:
	current_steps = min_steps

	if debug_enabled:
		print("[PLAYER] Steps reset to", current_steps)

	emit_signal("steps_changed", current_steps, max_steps)


# -------------------------
# INPUT & MOVEMENT
# -------------------------
func handle_grid_input() -> void:
	if not can_move():
		if debug_enabled:
			print("[PLAYER] ❌ Cannot move — out of steps")

		emit_signal("out_of_steps")
		return

	var dir := Vector2.ZERO
	var ray_index := -1

	if Input.is_action_just_pressed("right"):
		dir = Vector2.RIGHT
		ray_index = 0
	elif Input.is_action_just_pressed("left"):
		dir = Vector2.LEFT
		ray_index = 1
	elif Input.is_action_just_pressed("down"):
		dir = Vector2.DOWN
		ray_index = 2
	elif Input.is_action_just_pressed("up"):
		dir = Vector2.UP
		ray_index = 3

	if ray_index == -1:
		return

	if debug_enabled:
		print("[PLAYER] Input detected | Dir:", dir)

	if ray_index >= move_rays.size() or move_rays[ray_index] == null:
		if debug_enabled:
			print("[PLAYER] ❌ RayCast missing at index", ray_index)
		return

	var ray := move_rays[ray_index]
	ray.force_raycast_update()

	if ray.is_colliding():
		var collider := ray.get_collider()

		if debug_enabled:
			print(
				"[PLAYER] Ray hit:",
				collider,
				"| At:",
				ray.get_collision_point()
			)

		if collider is Pushable:
			if debug_enabled:
				print("[PLAYER] Attempting to push Pushable")

			if collider.can_be_pushed(dir):
				await collider.push(dir)
				await move_one_cell(dir)
			else:
				if debug_enabled:
					print("[PLAYER] ❌ Pushable blocked")
			return
		else:
			if debug_enabled:
				print("[PLAYER] ❌ Movement blocked by non-pushable")
			return

	await move_one_cell(dir)


func move_one_cell(direction: Vector2) -> void:
	is_moving = true
	idle_time = 0.0

	var target_pos := global_position + Vector2(
		direction.x * cell_size.x,
		direction.y * cell_size.y
	)

	if debug_enabled:
		print("[PLAYER] ▶ Moving from", global_position, "to", target_pos)

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "global_position", target_pos, move_duration)

	var squash := Vector2.ONE
	if abs(direction.x) > 0:
		squash = Vector2(1.0 + squash_strength, 1.0 - squash_strength)
	else:
		squash = Vector2(1.0 - squash_strength, 1.0 + squash_strength)

	tween.parallel().tween_property(sprite, "scale", squash, squash_duration)
	tween.tween_property(sprite, "scale", Vector2.ONE, squash_duration)

	await tween.finished

	current_steps += 1
	current_steps = clamp(current_steps, min_steps, max_steps)

	if debug_enabled:
		print("[PLAYER] ✅ Step used | Steps:", current_steps, "/", max_steps)

	emit_signal("steps_changed", current_steps, max_steps)

	if current_steps >= max_steps:
		if debug_enabled:
			print("[PLAYER] ⚠️ Out of steps")
		emit_signal("out_of_steps")

	is_moving = false


func idle_wiggle(delta: float) -> void:
	if is_moving:
		return

	idle_time += delta * idle_wiggle_speed
	var wiggle := sin(idle_time) * idle_wiggle_scale
	sprite.scale = Vector2.ONE + Vector2(wiggle, -wiggle)
