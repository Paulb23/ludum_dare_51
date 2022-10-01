extends Resource
class_name character_stats

@export var is_player : bool = false

@export var name : String = ""

@export var max_allocated_stats : int = 18

# inventory
@export var gold : int = 0

@export var main_weapon : weapon = preload("res://entities/weapons/unarmed.tres")
@export var secondary_weapon : weapon = preload("res://entities/weapons/unarmed.tres")

# Amount of stats
@export var health : int = 1
@export var stamina : int = 1
@export var mana : int = 1

# Defence stats
@export var agility : int = 1
@export var constitution : int = 1

# Offensive stats
@export var strength : int = 1
@export var wisdom : int = 1

# other
@export var luck : int = 1

func get_total_allocated_stats() -> int:
	return health + stamina + mana + agility + constitution + strength + wisdom + luck

func get_allocations_remaining() -> int:
	return max_allocated_stats - get_total_allocated_stats()