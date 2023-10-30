extends Control

const Tile = preload("res://frontiers/Tile.gd")

signal tile_clicked

class_name TileRegister

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var register = {}

func setUp()-> void:
	setTileTerrain(2, Vector2(5.0, 2.0))
	setTileBuilding(6, Vector2(5.0, 2.0))

		
func getAdyacentTiles(coord: Vector2) -> Array:
	var adyacent = []
	var coords = []
	if (int(coord.x) % 2): 
		coords.append(Vector2(coord.x, coord.y - 1))
		coords.append(Vector2(coord.x + 1, coord.y))
		coords.append(Vector2(coord.x + 1, coord.y + 1))
		coords.append(Vector2(coord.x, coord.y + 1))
		coords.append(Vector2(coord.x - 1, coord.y + 1))
		coords.append(Vector2(coord.x - 1, coord.y))
	else:
		coords.append(Vector2(coord.x, coord.y - 1))
		coords.append(Vector2(coord.x + 1, coord.y - 1))
		coords.append(Vector2(coord.x + 1, coord.y))
		coords.append(Vector2(coord.x, coord.y + 1))
		coords.append(Vector2(coord.x - 1, coord.y))
		coords.append(Vector2(coord.x - 1, coord.y - 1))
		
	for coord in coords:
		if coordWithinBounds(coord):
			adyacent.append(getTileAt(coord))

	return adyacent

func getTileAt(coord: Vector2)-> Tile:
	var key = coord.x * 1000 + coord.y
	if not key in register:
		register[key] = Tile.new()
		register[key].location = coord
	
	return register[key]

func setTileAt(coord: Vector2, tile: Tile)-> void:
	var key = coord.x * 1000 + coord.y
	register[key] = tile


func setTileTerrain(terrain_type: int, coord: Vector2) -> void:
	var tile = getTileAt(coord)
	tile.terrain_type = terrain_type
	setTileAt(coord, tile)
	$Tiles.set_cellv(coord, terrain_type)

func setTileBuilding(building_type: int, coord: Vector2) -> void:
	var tile = getTileAt(coord)
	tile.building_type = building_type
	setTileAt(coord, tile)
	$Buildings.set_cellv(coord, building_type)

func _input(ev):
	if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT and ev.pressed:
		var tilePos = pixelToTileCoord(ev.global_position)
		print(tilePos)
		emit_signal("tile_clicked", tilePos)

func pixelToTileCoord(pixel: Vector2) -> Vector2:
	var tileX = pixel.x / FRO.TILE_SIZE_X
	var yVal = pixel.y
	print(int(tileX) % 2)
	if int(tileX) % 2:
		yVal -= (FRO.TILE_SIZE_Y / 2)
	var tileY = yVal / FRO.TILE_SIZE_Y
	
	tileX = floor(tileX)
	tileY = floor(tileY)
	
	return Vector2(tileX, tileY)
	
func coordWithinBounds(coord: Vector2) -> bool:
	if coord.x < 0 or coord.x > FRO.MAP_LIMIT_X:
		return false
	if coord.y < 0 or coord.y > FRO.MAP_LIMIT_Y:
		return false
	return true
	
