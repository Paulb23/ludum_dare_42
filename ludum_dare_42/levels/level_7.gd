extends TileMap

var switched_tiles = {
	Vector2(14, -1):
	[
		{
			Vector2(13,0): 0,
			Vector2(13,1): 0
		}
	]
}

func switch_pressed(tile: Vector2) -> void:
	print(tile)
	if (not switched_tiles.has(tile)):
		return

	for new_tiles in switched_tiles[tile]:
		for cell in new_tiles:
			set_cellv(cell, new_tiles[cell])