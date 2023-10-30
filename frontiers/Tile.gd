extends Reference

class_name Tile

var terrain_type : int
var building_type : int
var flora_type : int
var location : Vector2

func _init():
	terrain_type = -1
	building_type = -1
	flora_type = -1
	location = Vector2(-1001.0,-1001.0)
