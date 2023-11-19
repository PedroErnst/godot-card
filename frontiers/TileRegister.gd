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
		if not getTileAt(coord).hasCity():
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
	for deadUnit in $DeadUnits.get_children():
		$DeadUnits.remove_child(deadUnit)
	autoSpawnTiles()

func autoSpawnTiles() -> void:
	for tileKey in register:
		var tile = register[tileKey]
		if not tile.hasCity():
			continue
		var bestTarget = null
		var bestScore = -99
		for coord in trackedCoords:
			if Grid.tileDistance(coord, tile.location) > tile.city_size:
				continue
			var target = getTileAt(coord)
			if target != null and target.terrain_type != FRO.TERRAIN_NONE:
				continue
			var score =  rand_range(0, 100)
			if score > bestScore:
				bestScore = score
				bestTarget = target
		if bestScore < 0:
			continue
		var options = []
		options.append(FRO.TERRAIN_SPAWN_MIX[randi() % len(FRO.TERRAIN_SPAWN_MIX)])
		for adyacent in getAdyacentTiles(bestTarget.location):
			if adyacent.terrain_type != FRO.TERRAIN_NONE:
				options.append(adyacent.terrain_type)
		var chosen = options[randi() % len(options)]
		setTileTerrain(chosen, bestTarget.location)
		postTileReveal(bestTarget.location)
	pass

func unitAtLocation(coord: Vector2) -> Unit:
	for unit in $Units.get_children():
		if coord == unit.tileLocation:
			return unit
	return null

func dealDamageAtLocation(coord: Vector2, damage: int) -> bool:
	var unit = unitAtLocation(coord)
	if unit == null:
		return false
	unit.hit_points = unit.hit_points - damage
	if unit.hit_points <= 0:
		processUnitDeath(unit)
		return true
	return false
		
func processUnitDeath(unit: Unit) -> void:
	unit.visible = false
	$Units.remove_child(unit)
	$DeadUnits.add_child(unit)
	unit.onDeath()

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
		var pos = Grid.tileToPixel(coord)
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

func getTileAt(coord: Vector2)-> Tile:
	var key = coord.x * 1000 + coord.y
	if not key in register:
		register[key] = Tile.new()
		register[key].location = coord
	
	return register[key]

func getAdyacentTiles(coord: Vector2) -> Array:
	var adyacents = []
	for adyacent in Grid.getAdyacentCoords(coord):
		if Grid.coordWithinBounds(adyacent):
			adyacents.append(getTileAt(adyacent))

	return adyacents

func allTiles()-> Array:
	return register.values()

func setTileAt(coord: Vector2, tile: Tile)-> void:
	var key = coord.x * 1000 + coord.y
	register[key] = tile
	updateTrackedCoords(coord)

func updateTrackedCoords(coord: Vector2)-> void:
	if not isTrackedCoord(coord):
		trackedCoords.append(coord)
	for adyacent in Grid.getAdyacentCoords(coord):
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
		if Grid.tileDistance(coord, START_TILE) < unit[FRO.MIN_SPAWN_RANGE]:
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
	unit.onSpawn()
	instantMoveUnitTo(unit, coord)

func moveUnitOneStepCloserTo(unit: Unit, target: Vector2) -> bool:
	var currentDist = Grid.tileDistance(unit.tileLocation, target)
	for coord in Grid.getAdyacentCoords(unit.tileLocation):
		if Grid.tileDistance(coord, target) < currentDist:
			moveUnitTo(unit, coord)
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

func moveUnitTo(unit: Unit, coord: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(unit, 'position', Grid.tileCenter(Grid.tileToPixel(coord)), 1)
	unit.tileLocation = coord
	
func instantMoveUnitTo(unit: Unit, coord: Vector2) -> void:
	unit.position = Grid.tileCenter(Grid.tileToPixel(coord))
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
		var tilePos = Grid.pixelToTileCoord(ev.global_position)
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
		var dist = Grid.tileDistance(target, register[key].location)
		if dist < closestDistance:
			closestDistance = dist
	return closestDistance
#
