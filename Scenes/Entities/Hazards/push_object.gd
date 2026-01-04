extends StaticBody2D
class_name Pushable

@export var cell_size: Vector2i = Vector2i(22, 22)
@export var move_duration: float = 0.18

# Enable / disable debug logs
@export var debug_enabled: bool = true

# [Right, Left, Down, Up]
@export var push_rays: Array[RayCast2D]

var is_moving := false


func can_be_pushed(direction: Vector2) -> bool:
	if debug_enabled:
		print("[Pushable] can_be_pushed called | dir:", direction)

	if is_moving:
		if debug_enabled:
			print("[Pushable] ❌ Cannot push: already moving")
		return false

	var index := _dir_to_index(direction)
	if index == -1:
		if debug_enabled:
			print("[Pushable] ❌ Invalid direction:", direction)
		return false

	if index >= push_rays.size() or push_rays[index] == null:
		if debug_enabled:
			print("[Pushable] ❌ RayCast missing at index:", index)
		return false

	var ray := push_rays[index]
	ray.force_raycast_update()

	if ray.is_colliding():
		if debug_enabled:
			print(
				"[Pushable] ❌ Push blocked | Collider:",
				ray.get_collider(),
				"| At position:",
				ray.get_collision_point()
			)
		return false

	if debug_enabled:
		print("[Pushable] ✅ Push allowed in direction:", direction)

	return true


func push(direction: Vector2) -> void:
	if debug_enabled:
		print("[Pushable] push() requested | dir:", direction)

	if not can_be_pushed(direction):
		if debug_enabled:
			print("[Pushable] ❌ push() aborted")
		return

	is_moving = true

	var target_pos := global_position + Vector2(
		direction.x * cell_size.x,
		direction.y * cell_size.y
	)

	if debug_enabled:
		print(
			"[Pushable] ▶ Moving from",
			global_position,
			"to",
			target_pos
		)

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		self,
		"global_position",
		target_pos,
		move_duration
	)

	await tween.finished

	is_moving = false

	if debug_enabled:
		print("[Pushable] ✅ Push complete | New pos:", global_position)


func _dir_to_index(dir: Vector2) -> int:
	if dir == Vector2.RIGHT:
		return 0
	if dir == Vector2.LEFT:
		return 1
	if dir == Vector2.DOWN:
		return 2
	if dir == Vector2.UP:
		return 3

	if debug_enabled:
		print("[Pushable] ❌ _dir_to_index failed for:", dir)

	return -1
