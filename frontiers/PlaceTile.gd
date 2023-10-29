
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

func _on_Tiles_tile_clicked(tilePos: Vector2):
	if not awaiting_placement:
		return

	if not tilePlacementValid(tilePos, tileToPlace):
		return

	placeTile(tilePos)
	close(true)
	
func tilePlacementValid(tilePos: Vector2, definition: Dictionary)-> bool:
	var tiles = cfc.NMAP.board.get_node("Tiles")
	
	if not tiles.coordWithinBounds(tilePos):
		return false
	
	var tileAtLocation = tiles.get_cellv(tilePos)
	if tileAtLocation >= 0:
		return false
	
	var adyacentTiles = tiles.getAdyacentTiles(tilePos)
	var anyAdyacentExists = false
	for adyacent in adyacentTiles:
		if adyacent >= 0:
			anyAdyacentExists = true
			
	if not anyAdyacentExists:
		return false

	return true
	
func placeTile(tilePos: Vector2) -> void:
	var tiles = cfc.NMAP.board.get_node("Tiles")
	tiles.set_cellv(tilePos, tileToPlace.type)

func checkSuccessful() -> void:
	awaiting_placement = false
	emit_signal("tile_placement_exited", true)
	hide()

func close(code: bool) -> void:
	awaiting_placement = false
	tileToPlace = null
	emit_signal("tile_placement_exited", code)
	hide()
