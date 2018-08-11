extends Node2D

var current_level

var old_tile_map : TileMap
var current_tile_map : TileMap

func load_level(path : String) -> void:
	current_level = load(path)
	reload_level()

func reload_level() -> void:
	if (current_tile_map):
		current_tile_map.queue_free()
	current_tile_map = current_level.instance()
	add_child(current_tile_map)

func convert_world_to_map(coordinates : Vector2) -> Vector2:
	if (not current_tile_map):
		return Vector2(0,0)
	return current_tile_map.world_to_map(coordinates)

func convert_map_to_world(coordinates : Vector2) -> Vector2:
	if (not current_tile_map):
		return Vector2(0,0)
	return current_tile_map.map_to_world(coordinates)

func all_tiles_removed() -> bool:
	return current_tile_map.get_used_cells().size() == 2

func get_start_tile() -> Array:
	if (not current_tile_map):
		return Array()
	var start_tile : Array = current_tile_map.get_used_cells_by_id(1)
	assert(start_tile.size() > 0)
	return start_tile

func get_tile_id(coordinates : Vector2) -> int:
	if (not current_tile_map):
		return -1
	return 	current_tile_map.get_cellv(coordinates)

func set_tile_id(coordinates : Vector2, id : int):
	if (not current_tile_map):
		return
	current_tile_map.set_cellv(coordinates, id)