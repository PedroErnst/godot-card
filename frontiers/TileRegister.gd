extends Control

const Tile = preload("res://frontiers/Tile.gd")

signal tile_clicked

class_name TileRegister

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var register = {}

func setUp()-> void:
	setTileTerrain(2, Vector2(6.0, 2.0))

		
func getAdyacentTiles(coord: Vector2) -> Array:
	var adyacent = []
	var coords = [
		Vector2(coord.x, coord.y - 1),
		Vector2(coord.x, coord.y + 1),
		Vector2(coord.x - 1, coord.y),
		Vector2(coord.x + 1, coord.y),
	]
	if (int(coord.x) % 1): 
		coords.append(Vector2(coord.x + 1, coord.y + 1))
		coords.append(Vector2(coord.x - 1, coord.y + 1))
	else:
		coords.append(Vector2(coord.x - 1, coord.y - 1))
		coords.append(Vector2(coord.x + 1, coord.y - 1))
		
	for coord in coords:
		if coordWithinBounds(coord):
			adyacent.append(getTileAt(coord))

	return adyacent

func getTileAt(coord: Vector2)-> Tile:
	var key = coord.x * 1000 + coord.y
	if not key in register:
		register[key] = Tile.new()
	
	return register[key]

func setTileAt(coord: Vector2, tile: Tile)-> void:
	var key = coord.x * 1000 + coord.y
	register[key] = tile


func setTileTerrain(terrain_type: int, coord: Vector2) -> void:
	var tile = getTileAt(coord)
	tile.terrain_type = terrain_type
	setTileAt(coord, tile)
	$Tiles.set_cellv(coord, terrain_type)

func _input(ev):
	if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT and ev.pressed:
		var tilePos = pixelToTileCoord(ev.global_position)
		var exactPos = pixel_to_flat_hex(ev.global_position)
		print(tilePos)
		print(exactPos)
		emit_signal("tile_clicked", tilePos)

func pixelToTileCoord(pixel: Vector2) -> Vector2:
	var tileX = pixel.x / FRO.TILE_SIZE_X
	var tileY = pixel.y / FRO.TILE_SIZE_Y
	
	tileX = floor(tileX)
	tileY = floor(tileY)
	
	return Vector2(tileX, tileY)
	
func coordWithinBounds(coord: Vector2) -> bool:
	if coord.x < 0 or coord.x > FRO.MAP_LIMIT_X:
		return false
	if coord.y < 0 or coord.y > FRO.MAP_LIMIT_Y:
		return false
	return true
	
	
func cube_to_coord(hex: Vector3) -> Vector2:
	var col = hex.x
	var row = hex.y + (hex.x - (int(hex.x)%1)) / 2
	return Vector2(col, row)

func coord_to_cube(hex: Vector2) -> Vector3:
	var q = hex.x
	var r = hex.y - (hex.x - (int(hex.x)%1)) / 2
	return Vector3(q, r, -q-r)

func cube_to_axial(cube: Vector3) -> Vector2:
	var q = cube.x
	var r = cube.y
	return Vector2(q, r)

func axial_to_cube(hex: Vector2) -> Vector3:
	var q = hex.x
	var r = hex.y
	var s = -q-r
	return Vector3(q, r, s)

func axial_round(hex: Vector2) -> Vector2:
	return cube_to_axial(cube_round(axial_to_cube(hex)))

func cube_round(frac: Vector3) -> Vector3:
	var q = round(frac.x)
	var r = round(frac.y)
	var s = round(frac.z)

	var q_diff = abs(q - frac.x)
	var r_diff = abs(r - frac.y)
	var s_diff = abs(s - frac.z)

	if q_diff > r_diff and q_diff > s_diff:
		q = -r-s
	elif r_diff > s_diff:
		r = -q-s
	else:
		s = -q-r

	return Vector3(q, r, s)
	
func axial_to_oddq(hex: Vector2) -> Vector2:
	var col = hex.x
	var row = hex.y + (hex.x - (int(hex.x)%2)) / 2
	return Vector2(col, row)

func oddq_to_axial(hex: Vector2) -> Vector2:
	var q = hex.x
	var r = hex.y - (hex.x - (int(hex.x)%2)) / 2
	return Vector2(q, r)

func pixel_to_flat_hex(point: Vector2) -> Vector2:
	var q = ((2.0/3.0) * point.x                        ) / FRO.TILE_SIZE_X
	var r = ((-1.0/3.0) * point.x  +  (sqrt(3.0)/3.0) * point.y) / FRO.TILE_SIZE_Y
	return axial_to_oddq(axial_round(Vector2(q, r)))
