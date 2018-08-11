extends Node2D

const START_TILE_ID = 1
const END_TILE_ID = 2
const DOUBLE_TILE_ID = 3
const SWITCH_TILE_ID = 4

var current_level

var old_tile_map : TileMap
var current_tile_map : TileMap
var loading : bool = false

func load_level(path : String) -> void:
	current_level = load(path)
	reload_level()

func reload_level() -> void:
	if (current_tile_map):
		current_tile_map.queue_free()
	current_tile_map = current_level.instance()
	add_child(current_tile_map)
	current_tile_map.position.y = 100
	loading = true

func _physics_process(delta : float) -> void:
	if (loading):
		current_tile_map.position.y -= 5

		if (current_tile_map.position.y == 0):
			loading = false


func convert_world_to_map(coordinates : Vector2) -> Vector2:
	if (not current_tile_map):
		return Vector2(0,0)
	return current_tile_map.world_to_map(coordinates)

func convert_map_to_world(coordinates : Vector2) -> Vector2:
	if (not current_tile_map):
		return Vector2(0,0)
	return current_tile_map.map_to_world(coordinates)

func all_tiles_removed() -> bool:
	return (current_tile_map.get_used_cells().size() - current_tile_map.get_used_cells_by_id(SWITCH_TILE_ID).size()) == 2

func get_start_tile() -> Array:
	if (not current_tile_map):
		return Array()
	var start_tile : Array = current_tile_map.get_used_cells_by_id(START_TILE_ID)
	assert(start_tile.size() > 0)
	return start_tile

func moved_to(tile : Vector2) -> void:
	if (not current_tile_map):
		return
	var tile_id : int = get_tile_id(tile)
	if (tile_id == SWITCH_TILE_ID):
		current_tile_map.switch_pressed(tile)
		return

func remove_tile(tile : Vector2) -> void:
	if (not current_tile_map):
		return
	var tile_id : int = get_tile_id(tile)
	if (tile_id == SWITCH_TILE_ID):
		return

	if (tile_id == DOUBLE_TILE_ID):
		var meta = String(tile.x) + String(tile.y)
		if (not current_tile_map.has_meta(meta)):
			current_tile_map.set_meta(meta, true)
			return

	if (tile_id != START_TILE_ID and tile_id != END_TILE_ID):
		set_tile_id(tile, -1)

func get_tile_id(coordinates : Vector2) -> int:
	if (not current_tile_map):
		return -1
	return 	current_tile_map.get_cellv(coordinates)

func set_tile_id(coordinates : Vector2, id : int):
	if (not current_tile_map):
		return
	current_tile_map.set_cellv(coordinates, id)