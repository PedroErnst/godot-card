
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
		return false
	
	var tileAtLocation = tiles.getTileAt(tilePos)
	if "rules" in definition:
		for ruleKey in definition.rules:
			if ruleKey == "terrain_type":
				if tileAtLocation.terrain_type != definition.rules[ruleKey]:
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
					return false
	
	var adyacentTiles = tiles.getAdyacentTiles(tilePos)
	var anyAdyacentExists = false
	for adyacent in adyacentTiles:
		if adyacent.terrain_type >= 0:
			anyAdyacentExists = true
			
	if not anyAdyacentExists:
		return false

	return true
	
func placeTile(tilePos: Vector2) -> void:
	var tiles = cfc.NMAP.board.get_node("TileRegister")
	if tileToPlace.layer == "terrain":
		tiles.setTileTerrain(tileToPlace.type, tilePos)
	elif tileToPlace.layer == "building":
		tiles.setTileBuilding(tileToPlace.type, tilePos)

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
