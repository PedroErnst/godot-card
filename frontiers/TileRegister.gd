extends Control

const Tile = preload("res://frontiers/Tile.gd")
var UNIT_DEFINITIONS = preload("res://frontiers/units/UnitDefinitions.gd").UNIT_DEFINITIONS

signal tile_clicked
signal right_clicked

class_name TileRegister

const DISPLAY_COORDS = 1
const DISPLAY_FOOD_COST = 2
const START_TILE = Vector2(11.0, 3.0)

var register = {}
var city_count = 0
var trackedCoords = []
var tileLabels = []
var minX = 999
var maxX = -999
var minY = 999
var maxY = -999

func allCitiesDestroyed() -> bool:
	for coord in getTrackedCoords():
		if getTileAt(coord).city_size > 0:
			return false
	return true

func getTrackedCoords()-> Array:
	return trackedCoords

func setUp()-> void:
	setTileTerrain(2, START_TILE)
	createCity(START_TILE)
	
func endTurn() -> void:
	for unit in $Units.get_children():
		if unit.faction == FRO.ENEMY:
			if unit.damage > 0:
				if attackAtPosition(unit):
					continue
			if unit.movement > 0:
				if moveUnitOneStepCloserTo(unit, START_TILE):
					continue

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
	
func displayTileCoords()-> void:
	displayTileLabels(DISPLAY_COORDS)
	
func displayFoodCosts()-> void:
	displayTileLabels(DISPLAY_FOOD_COST, FRO.TILE_SIZE_X / 3)
	
func clearTileLabels()-> void:
	for label in tileLabels:
		remove_child(label)
	tileLabels = []
	
func displayTileLabels(type: int, xOff: float = 0, yOff: float = 0)-> void:
	for coord in getTrackedCoords():
		var name_label = Label.new()
		if type == DISPLAY_COORDS:
			name_label.text = str(coord)
		elif type == DISPLAY_FOOD_COST:
			var cost = distanceToClosestCity(coord)
			if cost < 1:
				continue
			name_label.text = str(cost - 1)
		var pos = tileToPixel(coord)
		pos.y += FRO.TILE_SIZE_Y / 3
		pos.y += yOff
		pos.x += xOff
		name_label.set_position(pos)
		name_label.add_color_override("font_color", Color(Color.darkred))
		add_child(name_label)
		tileLabels.append(name_label)

func foodRequiredToGrowCityAt(coord: Vector2)-> int:
	var tile = getTileAt(coord)
	return tile.city_size * tile.city_size

func getAdyacentCoords(coord: Vector2) -> Array:
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

func getAdyacentTiles(coord: Vector2) -> Array:
	var adyacents = []
	for adyacent in getAdyacentCoords(coord):
		if coordWithinBounds(adyacent):
			adyacents.append(getTileAt(adyacent))

	return adyacents

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
	updateTrackedCoords(coord)

func updateTrackedCoords(coord: Vector2)-> void:
	if not isTrackedCoord(coord):
		trackedCoords.append(coord)
	for adyacent in getAdyacentCoords(coord):
		if not isTrackedCoord(adyacent):
			trackedCoords.append(adyacent)
	
func isTrackedCoord(coord: Vector2)-> bool:
	for tracked in trackedCoords:
		if coord == tracked:
			return true
	return false

func setTileTerrain(terrain_type: int, coord: Vector2) -> void:
	var tile = getTileAt(coord)
	tile.terrain_type = terrain_type
	setTileAt(coord, tile)
	$Tiles.set_cellv(coord, terrain_type)
	
func postTileReveal(coord: Vector2)-> void:
	spawnEnemiesIfNeeded(coord)

func spawnEnemiesIfNeeded(coord: Vector2) -> void:
	if rand_range(0, 100) > FRO.ENEMY_SPAWN_BASE_CHANCE:
		return
	var weight = -1.0
	var chosen = ''
	for key in UNIT_DEFINITIONS:
		var unit = UNIT_DEFINITIONS[key]
		if tileDistance(coord, START_TILE) < unit[FRO.MIN_SPAWN_RANGE]:
			continue
		var roll = rand_range(0.0, 100.0) * unit[FRO.SPAWN_WEIGHT]
		if roll > weight:
			weight = roll
			chosen = key
	if weight < 0.0:
		return
	spawnUnit(coord, chosen, UNIT_DEFINITIONS[chosen], FRO.ENEMY)

func spawnUnit(coord: Vector2, unitName: String, def: Dictionary, faction: int) -> void:
	var unitPath = CFConst.PATH_UNITS + unitName + ".tscn"
	var template = load(unitPath)
	var unit = template.instance()
	$Units.add_child(unit)
	unit.init(faction, UNIT_DEFINITIONS[unitName])
	setUnitPosition(unit, coord)

func moveUnitOneStepCloserTo(unit: Unit, target: Vector2) -> bool:
	var currentDist = tileDistance(unit.tileLocation, target)
	for coord in getAdyacentCoords(unit.tileLocation):
		if tileDistance(coord, target) < currentDist:
			setUnitPosition(unit, coord)
			return true
	return false

func attackAtPosition(unit: Unit) -> bool:
	var coord = unit.tileLocation
	var building = getTileBuilding(coord)
	var tile = getTileAt(coord)
	if building == FRO.BUILDING_NONE:
		return false
	setTileBuilding(FRO.BUILDING_NONE, coord)
	tile.city_size = 0
	return true
	
func setUnitPosition(unit: Unit, coord: Vector2) -> void:
	unit.position = tileCenter(tileToPixel(coord))
	unit.tileLocation = coord

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
	
func getTileBuilding(coord: Vector2) -> int:
	var tile = getTileAt(coord)
	return tile.building_type

func _input(ev):
	if ev is InputEventMouseButton and ev.button_index == BUTTON_LEFT and ev.pressed:
		var tilePos = pixelToTileCoord(ev.global_position)
		print(tilePos)
		print(distanceToClosestCity(tilePos))
		emit_signal("tile_clicked", tilePos)
	if ev is InputEventMouseButton and ev.button_index == BUTTON_RIGHT and ev.pressed:
		emit_signal("right_clicked")
		
func distanceToClosestCity(target: Vector2)-> int:
	var closestDistance = 999
	for key in register:
		if register[key].city_size < 1:
			continue
		var dist = tileDistance(target, register[key].location)
		if dist < closestDistance:
			closestDistance = dist
	return closestDistance


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

func tileToPixel(tile: Vector2) -> Vector2:
	var pixelX = tile.x * FRO.TILE_SIZE_X
	var pixelY = tile.y * FRO.TILE_SIZE_Y
	if int(tile.x) % 2:
		pixelY += (FRO.TILE_SIZE_Y / 2)
	
	return Vector2(pixelX, pixelY)

func tileCenter(pixelCoord: Vector2) -> Vector2:
	return Vector2(pixelCoord.x + (FRO.TILE_SIZE_X / 2), pixelCoord.y + (FRO.TILE_SIZE_Y / 2))
	
func coordWithinBounds(coord: Vector2) -> bool:
	if coord.x < 0 or coord.x > FRO.MAP_LIMIT_X:
		return false
	if coord.y < 0 or coord.y > FRO.MAP_LIMIT_Y:
		return false
	return true
	
func axial_to_oddq(hex: Vector2)-> Vector2:
	var col = hex.x
	var row = hex.y + (hex.x - (int(hex.x) % 2)) / 2
	return Vector2(col, row)

func oddq_to_axial(hex: Vector2)-> Vector2:
	var q = hex.x
	var r = hex.y - (hex.x - (int(hex.x) % 2)) / 2
	return Vector2(q, r)
	
func tileDistance(a: Vector2, b: Vector2)-> int:
	return axial_distance(oddq_to_axial(a), oddq_to_axial(b))
	
func axial_subtract(a: Vector2, b: Vector2)-> Vector2:
	return Vector2(a.x - b.x, a.y - b.y)

func axial_distance(a: Vector2, b: Vector2)-> int:
	var vec = axial_subtract(a, b)
	var floatVal = (abs(vec.x)
		  + abs(vec.x + vec.y)
		  + abs(vec.y)) / 2
	return int(floatVal)

