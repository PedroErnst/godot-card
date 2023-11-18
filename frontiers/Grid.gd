
class_name Grid

static func pixelToTileCoord(pixel: Vector2) -> Vector2:
	var tileX = pixel.x / FRO.TILE_SIZE_X
	var yVal = pixel.y
	print(int(tileX) % 2)
	if int(tileX) % 2:
		yVal -= (FRO.TILE_SIZE_Y / 2)
	var tileY = yVal / FRO.TILE_SIZE_Y
	
	tileX = floor(tileX)
	tileY = floor(tileY)
	
	return Vector2(tileX, tileY)

static func tileToPixel(tile: Vector2) -> Vector2:
	var pixelX = tile.x * FRO.TILE_SIZE_X
	var pixelY = tile.y * FRO.TILE_SIZE_Y
	if int(tile.x) % 2:
		pixelY += (FRO.TILE_SIZE_Y / 2)
	
	return Vector2(pixelX, pixelY)

static func tileCenter(pixelCoord: Vector2) -> Vector2:
	return Vector2(pixelCoord.x + (FRO.TILE_SIZE_X / 2), pixelCoord.y + (FRO.TILE_SIZE_Y / 2))
	
static func coordWithinBounds(coord: Vector2) -> bool:
	if coord.x < 0 or coord.x > FRO.MAP_LIMIT_X:
		return false
	if coord.y < 0 or coord.y > FRO.MAP_LIMIT_Y:
		return false
	return true
	
static func axial_to_oddq(hex: Vector2)-> Vector2:
	var col = hex.x
	var row = hex.y + (hex.x - (int(hex.x) % 2)) / 2
	return Vector2(col, row)

static func oddq_to_axial(hex: Vector2)-> Vector2:
	var q = hex.x
	var r = hex.y - (hex.x - (int(hex.x) % 2)) / 2
	return Vector2(q, r)
	
static func tileDistance(a: Vector2, b: Vector2)-> int:
	return axial_distance(oddq_to_axial(a), oddq_to_axial(b))
	
static func axial_subtract(a: Vector2, b: Vector2)-> Vector2:
	return Vector2(a.x - b.x, a.y - b.y)

static func axial_distance(a: Vector2, b: Vector2)-> int:
	var vec = axial_subtract(a, b)
	var floatVal = (abs(vec.x)
		  + abs(vec.x + vec.y)
		  + abs(vec.y)) / 2
	return int(floatVal)

static func getAdyacentCoords(coord: Vector2) -> Array:
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
	return coords
