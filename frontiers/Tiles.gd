extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal tile_clicked

const SIZE_X = 54
const SIZE_Y = 72

const MAP_LIMIT_X = 22
const MAP_LIMIT_Y = 5


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

func pixelToTileCoord(pixel: Vector2) -> Vector2:
	var tileX = pixel.x / SIZE_X
	var tileY = pixel.y / SIZE_Y
	
	tileX = floor(tileX)
	tileY = floor(tileY)
	
	return Vector2(tileX, tileY)
