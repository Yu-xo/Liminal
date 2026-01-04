extends Node2D
class_name NPCBase

enum NPCType { SHOVEL, WATER, CROWN }

@export var npc_type: NPCType
@export var timeline_name: String
@export var wisdom_flag: String
@export var next_scene: String
