extends TileMap

var switched_tiles = {
	Vector2(15, 1):
	[
		{
			Vector2(16,1): 0,
			Vector2(17,1): 0
		}
	],
	Vector2(20, -1):
	[
		{
			Vector2(16,-3): 0,
			Vector2(17,-3): 0
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