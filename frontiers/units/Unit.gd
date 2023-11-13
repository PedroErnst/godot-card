extends Node2D

class_name Unit

export var hit_points = 0
export var faction = 0
export var movement = 0
export var damage = 0
var tileLocation = 0

func init(factionKey: int, def: Dictionary) -> void:
	faction = factionKey
	hit_points = def[FRO.HIT_POINTS]
	movement = def[FRO.MOVEMENT]
	damage = def[FRO.DAMAGE]
