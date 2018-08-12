extends TileMap

var switched_tiles = {
	Vector2(16, 4):
	[
		{
			Vector2(13,1): 0,
			Vector2(14,1): 0,
			Vector2(15,1): 0
		}
	],
	Vector2(10, 1):
	[
		{
			Vector2(16,0): 0,
			Vector2(16,-1): 0
		}
	]
}

func switch_pressed(tile: Vector2) -> void:
	if (not switched_tiles.has(tile)):
		return

	for new_tiles in switched_tiles[tile]:
		for cell in new_tiles:
			set_cellv(cell, new_tiles[cell])