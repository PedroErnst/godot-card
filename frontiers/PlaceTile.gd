
extends Control

const Tile = preload("Tile.gd")

signal tile_placement_exited

var awaiting_placement = false
var tileToPlace = null
var placementLocation = null

func _ready() -> void:
	hide()
	
func isBusy() -> bool:
	return awaiting_placement
	
func askToPlaceTile(tileDefinition: Dictionary) -> void:
	tileToPlace = Tile.new(tileDefinition)
	tileToPlace = Tile.new(tileDefinition)
	awaiting_placement = true
	show()

func _on_Cancel_pressed():
	close(false)

func _on_Tiles_tile_clicked(tilePos: Vector2):
	if not awaiting_placement:
		return

	placeTile(tilePos)
	close(true)
	
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
