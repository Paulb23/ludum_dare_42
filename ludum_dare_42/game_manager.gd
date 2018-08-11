extends Node2D

func _ready() -> void:
	_reset()
	$player.connect("fallen", self, "_reset")

func _reset() -> void:
	var start_id : Array = $TileMap.get_used_cells_by_id(1)
	assert(start_id.size() > 0)
	$player.set_start_tile(start_id.pop_back())