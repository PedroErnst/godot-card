extends TileMap

var tilemap_size = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _draw():
	var color = Color(100.0, 0.0, 0.0)

	draw_set_transform(Vector2(), 0, tilemap_size)

	for x in range(0, FRO.MAP_LIMIT_X + 1):
		for y in range(0, FRO.MAP_LIMIT_Y +1 ):
			var offset = 0
			if int(x) % 2:
				offset = FRO.TILE_SIZE_Y / 2
			var rect = Rect2(
				float(x * FRO.TILE_SIZE_X),
				float(y * FRO.TILE_SIZE_Y) + float(offset),
				float(FRO.TILE_SIZE_X),
				float(FRO.TILE_SIZE_Y)
			)
			draw_rect(rect, color, false)

