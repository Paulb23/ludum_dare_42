extends Node2D

enum Angle {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	VERTICAL
}

var start = false

var current_tile : Vector2
var start_tile : Vector2
var current_angle : int = VERTICAL

func _ready() -> void:
	pass

func _physics_process(delta : float) -> void:
	if (not start):
		return

	if (Input.is_action_just_pressed("ui_up")):
		current_tile.x -= 1
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

	if (Input.is_action_just_pressed("ui_down")):
		current_tile.x += 1
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

	if (Input.is_action_just_pressed("ui_left")):
		current_tile.y += 1
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

	if (Input.is_action_just_pressed("ui_right")):
		current_tile.y -= 1
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

	position = convert_map_to_world(current_tile)
	position.x -= 0
	position.y += 10

func set_start_tile(start_tile : Vector2) -> void:
	self.start_tile = start_tile
	self.current_tile = start_tile
	start = true
	position = convert_world_to_map(start_tile)
	current_angle = VERTICAL

func convert_world_to_map(coordinates : Vector2) -> Vector2:
	return get_parent().get_node("TileMap").world_to_map(coordinates)

func convert_map_to_world(coordinates : Vector2) -> Vector2:
	return get_parent().get_node("TileMap").map_to_world(coordinates)