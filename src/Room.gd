tool
extends Node2D

enum Direction {
	Up,
	Right,
	Down,
	Left,
}

enum Tile {
	Open,
	Wall,
	Corner,
	Door,
}

export(bool) var door_up := true setget enable_door_up
export(bool) var door_right := true setget enable_door_right
export(bool) var door_down := true setget enable_door_down
export(bool) var door_left := true setget enable_door_left
export(bool) var collision_on := false setget enable_collision


func enable_collision(value: bool) -> void:
	collision_on = value
	$TileMap.collision_layer = int(collision_on)
	$TileMap.collision_mask = int(collision_on)


func enable_door_up(value: bool) -> void:
	door_up = value
	$TileMap.set_cell(1, 0, Tile.Door if value else Tile.Wall, false, value, true)


func enable_door_right(value: bool) -> void:
	door_right = value
	$TileMap.set_cell(2, 1, Tile.Door if value else Tile.Wall, !value)


func enable_door_down(value: bool) -> void:
	door_down = value
	$TileMap.set_cell(1, 2, Tile.Door if value else Tile.Wall, false, !value, true)


func enable_door_left(value: bool) -> void:
	door_left = value
	$TileMap.set_cell(0, 1, Tile.Door if value else Tile.Wall, value)
