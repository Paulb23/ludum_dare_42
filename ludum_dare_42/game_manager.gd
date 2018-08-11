extends Node2D

var levels = [
	"res://levels/level_1.tscn"
]

func _ready() -> void:
	$level.load_level(levels[0])
	$player.set_level($level)
	$player.connect("fallen", self, "_reset")
	_reset()

func _reset() -> void:
	$level.reload_level()
	var start_tile = $level.get_start_tile()
	assert(start_tile.size() > 0)
	$player.set_start_tile(start_tile.pop_back())