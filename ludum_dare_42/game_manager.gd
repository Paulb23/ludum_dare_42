extends Node2D

var current_level : int = 0

var levels = [
	"res://levels/level_1.tscn",
	"res://levels/level_2.tscn",
	"res://levels/level_3.tscn",
	"res://levels/level_4.tscn",
	"res://levels/level_5.tscn",
	"res://levels/level_6.tscn",
	"res://levels/level_7.tscn",
	"res://levels/level_8.tscn",
	"res://levels/level_9.tscn",
	"res://levels/level_10.tscn"
]

func _ready() -> void:
	set_process_input(true)
	$level.load_level(levels[current_level])
	$player.set_level($level)
	$player.connect("fallen", self, "_reset")
	$player.connect("end", self, "_end")

	$music/theme_1.play()
	_reset()

func _physics_process(delta : float) -> void:
	if (Input.is_action_just_pressed("reset")):
		_reset()
	if (Input.is_action_just_pressed("pause")):
		$pause_menu.display()
		get_tree().paused = true

func _input(event : InputEvent) -> void:
	if (event is InputEventKey and not event.is_echo() and event.is_pressed() and event.scancode == KEY_N):
		current_level += 1

		if (current_level >= levels.size()):
			Globals.set_scene("res://menus/game_win.tscn")
			return

		$level.load_level(levels[current_level])
		_reset()

	if (event is InputEventKey and not event.is_echo() and event.is_pressed() and event.scancode == KEY_B):
		current_level -= 1

		if (current_level < 0):
			current_level = 0

		$level.load_level(levels[current_level])
		_reset()

func _reset() -> void:
	$level.reload_level()
	var start_tile = $level.get_start_tile()
	assert(start_tile.size() > 0)
	$player.set_start_tile(start_tile.pop_back())

func _end() -> void:
	if ($level.all_tiles_removed()):
		$player.can_move = false
		$load.play()
		current_level += 1

		if (current_level >= levels.size()):
			yield($load, "finished")
			Globals.set_scene("res://menus/game_win.tscn")
			return

		$level.load_level(levels[current_level])
		_reset()