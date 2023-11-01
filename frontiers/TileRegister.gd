extends Control

const Tile = preload("res://frontiers/Tile.gd")

signal tile_clicked

class_name TileRegister

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var register = {}
var city_count = 0

func setUp()-> void:
	var startingTile = Vector2(5.0, 2.0)
	setTileTerrain(2, startingTile)
	createCity(startingTile)
	
func createCity(coord: Vector2)-> void:
	setTileBuilding(6, coord)
	var tile = getTileAt(coord)
	tile.newCity()
	setTileAt(coord, tile)
	city_count += 1
	
func growCity(coord: Vector2)-> void:
	var tile = getTileAt(coord)
	tile.growCity()
	setTileAt(coord, tile)

func foodRequiredToGrowCityAt(coord: Vector2)-> int:
	var tile = getTileAt(coord)
	return tile.city_size * tile.city_size

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

func allTiles()-> Array:
	return register.values()

func setTileAt(coord: Vector2, tile: Tile)-> void:
	var key = coord.x * 1000 + coord.y
	register[key] = tile


func setTileTerrain(terrain_type: int, coord: Vector2) -> void:
	var tile = getTileAt(coord)
	tile.terrain_type = terrain_type
	setTileAt(coord, tile)
	$Tiles.set_cellv(coord, terrain_type)


func setTileFlora(flora_type: int, coord: Vector2) -> void:
	var tile = getTileAt(coord)
	tile.flora_type = flora_type
	setTileAt(coord, tile)
	$Flora.set_cellv(coord, flora_type)

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
	
