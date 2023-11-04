
extends Control

signal tile_placement_exited

var awaiting_placement = false
var tileToPlace = null
var placementLocation = null

func _ready() -> void:
	hide()
	
func isBusy() -> bool:
	return awaiting_placement
	
func askToPlaceTile(tileDefinition: Dictionary) -> void:
	tileToPlace = tileDefinition
	awaiting_placement = true
	show()

func _on_Cancel_pressed():
	close(false)

func tilePlacementValid(tilePos: Vector2, definition: Dictionary)-> bool:
	var tiles = cfc.NMAP.board.get_node("TileRegister")
	
	if not tiles.coordWithinBounds(tilePos):
		showError("Outside of the map!")
		return false
	
	var tileAtLocation = tiles.getTileAt(tilePos)
	if "rules" in definition:
		for ruleKey in definition.rules:
			if ruleKey == "terrain_type":
				if tileAtLocation.terrain_type != definition.rules[ruleKey]:
					showError("Cannot be placed on this tile (incorrect terrain)")
					return false
			if ruleKey == "flora_type":
				if tileAtLocation.flora_type != definition.rules[ruleKey]:
					showError("Cannot be placed on this tile (incorrect vegetation)")
					return false
			if ruleKey == "city_size":
				if tileAtLocation.city_size < definition.rules[ruleKey]:
					showError("Must select a city")
					return false
			if ruleKey == "food_available":
				var required = tiles.foodRequiredToGrowCityAt(tilePos)
				var available = cfc.NMAP.board.get_node("Counters").get_counter("food")
				if available < required:
					showError("Requires " + str(required) + " food")
					return false
			if ruleKey == "adyacent_to":
				var adyacentType = definition.rules[ruleKey].type
				var adyacentId = definition.rules[ruleKey].id
				var hasMatchingAdyacent = false
				for tile in tiles.getAdyacentTiles(tilePos):
					if adyacentType == "building" and tile.building_type == adyacentId:
						hasMatchingAdyacent = true
					if adyacentType == "terrain" and tile.terrain_type == adyacentId:
						hasMatchingAdyacent = true
				if not hasMatchingAdyacent:
					showError("Must be adyacent to a specific other tile")
					return false
	
	var adyacentTiles = tiles.getAdyacentTiles(tilePos)
	var anyAdyacentExists = false
	for adyacent in adyacentTiles:
		if adyacent.terrain_type >= FRO.TERRAIN_NONE:
			anyAdyacentExists = true
			
	if not anyAdyacentExists and tileAtLocation.terrain_type < 0:
		showError("Must be adyacent to at least one other tile")
		return false

	return true
	
func showError(text: String)-> void:
	cfc.NMAP.board.get_node("Notification").showNotification(text, '', 3)
	
func placeTile(tilePos: Vector2) -> void:
	var tiles = cfc.NMAP.board.get_node("TileRegister")
	var counter = cfc.NMAP.board.get_node("Counters")
	if tileToPlace.layer == "terrain":
		tiles.setTileTerrain(tileToPlace.type, tilePos)
		if "flora" in tileToPlace:
			for key in tileToPlace.flora:
				if rand_range(0, 100) < tileToPlace.flora[key]:
					tiles.setTileFlora(key, tilePos)
					break
	elif tileToPlace.layer == "building":
		tiles.setTileBuilding(tileToPlace.type, tilePos)
	elif tileToPlace.layer == "effect":
		if "flora" in tileToPlace:
			tiles.setTileFlora(tileToPlace.flora, tilePos)
		if "grow_city" in tileToPlace:
			var required = tiles.foodRequiredToGrowCityAt(tilePos)
			counter.mod_counter('food', -required)
			tiles.growCity(tilePos)
		if "resources" in tileToPlace:
			for resource in tileToPlace["resources"]:
				counter.mod_counter(resource, tileToPlace["resources"][resource])

func checkSuccessful() -> void:
	awaiting_placement = false
	emit_signal("tile_placement_exited", true)
	hide()

func close(code: bool) -> void:
	awaiting_placement = false
	tileToPlace = null
	emit_signal("tile_placement_exited", code)
	hide()


func _on_TileRegister_tile_clicked(tilePos: Vector2)-> void:
	if not awaiting_placement:
		return

	if not tilePlacementValid(tilePos, tileToPlace):
		return

	placeTile(tilePos)
	close(true)


func _on_TileRegister_right_clicked():
	close(false)
