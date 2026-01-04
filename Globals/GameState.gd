extends Node

var game_started := false

func _ready():
	print("[GameManager] Autoload READY")

func start_game():
	print("[GameManager] start_game() called")

	if game_started:
		print("[GameManager] Game already started, ignoring")
		return

	game_started = true
	_reset_game_state()
	_load_intro()

func _reset_game_state():
	print("[GameManager] Resetting game state")

	Dialogic.VAR.set_variable("wisdom_shovel", false)
	Dialogic.VAR.set_variable("wisdom_water", false)
	Dialogic.VAR.set_variable("wisdom_crown", false)

func _load_intro():
	print("[GameManager] Loading Entity Intro scene")
	get_tree().change_scene_to_file("res://Scenes/EntityIntro.tscn")

func load_shovel_stage():
	print("[GameManager] Loading Shovel stage")
	get_tree().change_scene_to_file("res://Scenes/Puzzle_Shovel.tscn")

func load_water_stage():
	print("[GameManager] Loading Water stage")
	get_tree().change_scene_to_file("res://Scenes/Puzzle_Water.tscn")

func load_crown_stage():
	print("[GameManager] Loading Crown stage")
	get_tree().change_scene_to_file("res://Scenes/Puzzle_Crown.tscn")

func load_final_entity():
	print("[GameManager] Loading Final Entity scene")
	get_tree().change_scene_to_file("res://Scenes/Entity_Final.tscn")

func end_game_live():
	print("[GameManager] Ending: LIVE")
	get_tree().change_scene_to_file("res://Scenes/Ending_Live.tscn")

func end_game_not_live():
	print("[GameManager] Ending: NOT LIVE")
	get_tree().change_scene_to_file("res://Scenes/Ending_NotLive.tscn")
