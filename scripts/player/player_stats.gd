extends Node
class_name PlayerStats

var shielding: bool = false

var base_health: int = 15
var base_mana: int = 10
var base_attack: int = 1
var base_magic_attack: int = 3
var base_defense: int = 1

var bonus_health: int = 0
var bonus_mana: int = 0
var bonus_attack: int = 0
var bonus_magic_attack: int = 0
var bonus_defense: int = 0

var current_health: int = 0 
var current_mana: int = 0

var max_health: int = 0
var max_mana: int = 0

var current_exp: int = 0

var level: int = 1
var level_dict: Dictionary = {
	"1": 25,
	"2": 33,
	"3": 49,
	"4": 66,
	"5": 93,
	"6": 135,
	"7": 186,
	"8": 251,
	"9": 356
}

func _ready() -> void:
	current_mana = base_mana + bonus_mana
	max_mana = current_mana
	
	current_health = base_health + bonus_health
	max_health = current_health

func update_exp(received_exp: int) -> void:
	current_exp += received_exp
	if (current_exp >= level_dict[str(level)] and level < level_dict.keys().size()):
		var leftover: int = current_exp - level_dict[str(level)]
		current_exp = leftover
		on_level_up()
		level += 1
	elif (current_exp >= level_dict[str(level)] && level == level_dict.keys().size()):
		current_exp = level_dict[str(level)]

func on_level_up() -> void:
	current_mana = base_mana + bonus_mana
	current_health = base_health + bonus_health
