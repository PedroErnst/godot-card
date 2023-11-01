extends Reference

class_name Tile

var terrain_type : int
var building_type : int
var flora_type : int
var location : Vector2
var city_size : int
var label: Label

func _init():
	terrain_type = -1
	building_type = -1
	flora_type = -1
	city_size = 0
	location = Vector2(-1001.0,-1001.0)

func newCity()-> void:
	city_size = 1
	label = Label.new()
	label.text = str(1)
	cfc.NMAP.board.add_child(label)
	var offset = 0
	if int(location.x) % 2 > 0:
		offset = FRO.TILE_SIZE_Y / 2
	label.rect_position.x = (location.x * FRO.TILE_SIZE_X) + 18
	label.rect_position.y = (location.y * FRO.TILE_SIZE_Y) + offset + 8

func growCity()-> void:
	city_size = city_size + 1
	label.text = str(city_size)
