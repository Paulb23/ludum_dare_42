extends Node2D

enum Angle {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	VERTICAL
}

signal fallen
signal end

var loading : bool = true
var falling : bool = false
var moving : bool = false
var can_move : bool = false

var current_tile : Vector2
var start_tile : Vector2
var current_angle : int = VERTICAL

var level : Node2D

func _ready() -> void:
	$move_delay.connect("timeout", self, "allow_movement")

func _physics_process(delta : float) -> void:

	if (loading):
		var target = convert_map_to_world(start_tile)
		if (position.y - target.y < 5):
			position.y += 5
		else:
			position.y = target.y + 10
			loading = false
		return

	if (can_move and not falling):
		if (get_tile_id(current_tile) == -1):
			falling = true

		match current_angle:
			VERTICAL:
				pass
			RIGHT:
				if (get_tile_id(Vector2(current_tile.x, current_tile.y - 1)) == -1):
					falling = true
			LEFT:
				if (get_tile_id(Vector2(current_tile.x, current_tile.y + 1)) == -1):
					falling = true
			UP:
				if (get_tile_id(Vector2(current_tile.x - 1, current_tile.y)) == -1):
					falling = true
			DOWN:
				if (get_tile_id(Vector2(current_tile.x + 1, current_tile.y)) == -1):
					falling = true
		if (falling):
			$sfx/fall_off.play()
			emit_signal("fallen")
			return

	if (falling or not can_move):
		return

	var previous_tile : Vector2 = current_tile
	var previous_angle : int = current_angle
	var moved : bool = false
	if (Input.is_action_pressed("ui_up")):
		current_tile.x -= 1
		moved = true
		match current_angle:
			VERTICAL:
				$AnimationPlayer.play("up")
				current_angle = UP
			LEFT:
				pass
			RIGHT:
				pass
			UP:
				current_tile.x -= 1
				$AnimationPlayer.play("vertical")
				current_angle = VERTICAL
			DOWN:
				$AnimationPlayer.play("vertical")
				current_angle = VERTICAL
	elif (Input.is_action_pressed("ui_down")):
		current_tile.x += 1
		moved = true
		match current_angle:
			VERTICAL:
				$AnimationPlayer.play("down")
				current_angle = DOWN
			LEFT:
				pass
			RIGHT:
				pass
			UP:
				$AnimationPlayer.play("vertical")
				current_angle = VERTICAL
			DOWN:
				current_tile.x += 1
				$AnimationPlayer.play("vertical")
				current_angle = VERTICAL
	elif (Input.is_action_pressed("ui_left")):
		current_tile.y += 1
		moved = true
		match current_angle:
			VERTICAL:
				$AnimationPlayer.play("left")
				current_angle = LEFT
			LEFT:
				current_tile.y += 1
				$AnimationPlayer.play("vertical")
				current_angle = VERTICAL
			RIGHT:
				$AnimationPlayer.play("vertical")
				current_angle = VERTICAL
			UP:
				pass
			DOWN:
				pass
	elif (Input.is_action_pressed("ui_right")):
		current_tile.y -= 1
		moved = true
		match current_angle:
			VERTICAL:
				$AnimationPlayer.play("right")
				current_angle = RIGHT
			RIGHT:
				current_tile.y -= 1
				$AnimationPlayer.play("vertical")
				current_angle = VERTICAL
			LEFT:
				$AnimationPlayer.play("vertical")
				current_angle = VERTICAL
			UP:
				pass
			DOWN:
				pass

	if (moved):
		var rand = int(rand_range(0, 1))
		$sfx.get_child(rand).play()
		position = convert_map_to_world(current_tile)
		position.x -= 0
		position.y += 10

		disllow_movement()
		$move_delay.start()

		remove_tile(previous_tile)
		match previous_angle:
			VERTICAL:
				pass
			RIGHT:
				remove_tile(Vector2(previous_tile.x, previous_tile.y - 1))
			LEFT:
				remove_tile(Vector2(previous_tile.x, previous_tile.y + 1))
			UP:
				remove_tile(Vector2(previous_tile.x - 1, previous_tile.y))
			DOWN:
				remove_tile(Vector2(previous_tile.x + 1, previous_tile.y))

		moved_to(current_tile)
		match current_angle:
			VERTICAL:
				pass
			RIGHT:
				moved_to(Vector2(current_tile.x, current_tile.y - 1))
			LEFT:
				moved_to(Vector2(current_tile.x, current_tile.y + 1))
			UP:
				moved_to(Vector2(current_tile.x - 1, current_tile.y))
			DOWN:
				moved_to(Vector2(current_tile.x + 1, current_tile.y))

		if (get_tile_id(current_tile) == 2):
			emit_signal("end")

func set_level(level : Node2D) ->void:
	self.level = level

func set_start_tile(start_tile : Vector2) -> void:
	self.start_tile = start_tile
	self.current_tile = start_tile
	position = convert_world_to_map(start_tile)
	position = convert_map_to_world(current_tile)
	position.x -= 0
	position.y = -100
	$AnimationPlayer.play("vertical")
	current_angle = VERTICAL
	falling = false
	loading = true
	disllow_movement()
	$move_delay.start()

func allow_movement() -> void:
	can_move = true

func disllow_movement() -> void:
	can_move = false

func convert_world_to_map(coordinates : Vector2) -> Vector2:
	if (not level):
		return Vector2(0,0)
	return level.convert_world_to_map(coordinates)

func convert_map_to_world(coordinates : Vector2) -> Vector2:
	if (not level):
		return Vector2(0,0)
	return level.convert_map_to_world(coordinates)

func get_tile_id(coordinates : Vector2) -> int:
	if (not level):
		return -1
	return 	level.get_tile_id(coordinates)

func remove_tile(tile : Vector2) -> void:
	if (not level):
		return
	level.remove_tile(tile)

func moved_to(tile : Vector2) -> void:
	if (not level):
		return
	level.moved_to(tile)