extends TileMap

signal tile_clicked

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(ev):
	if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT and ev.pressed:
		var tilePos = pixelToTileCoord(ev.global_position)
		var currentTile = get_cellv(tilePos)
		emit_signal("tile_clicked", tilePos)
		
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
			adyacent.append(get_cellv(coord))
	
	return adyacent
	
func coordWithinBounds(coord: Vector2) -> bool:
	if coord.x < 0 or coord.x > FRO.MAP_LIMIT_X:
		return false
	if coord.y < 0 or coord.y > FRO.MAP_LIMIT_Y:
		return false
	return true

func pixelToTileCoord(pixel: Vector2) -> Vector2:
	var tileX = pixel.x / FRO.TILE_SIZE_X
	var tileY = pixel.y / FRO.TILE_SIZE_Y
	
	tileX = floor(tileX)
	tileY = floor(tileY)
	
	return Vector2(tileX, tileY)
