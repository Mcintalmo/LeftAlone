extends Node2D

const ROOM_SCENE := preload("res://Scenes/Room.tscn")
const NPC_SCENE := preload("res://Scenes/NPC.tscn")
var _is_holding_next_room := false
const _WIDTH := 16
const _HEIGHT := 16
var _room_array := []

func _add_room(x: int,
			  y: int,
			  door_up: bool = true,
			  door_right: bool = true,
			  door_down: bool = true,
			  door_left: bool = true) -> void:
	var room_instance := ROOM_SCENE.instance()
	room_instance.door_up = door_up
	room_instance.door_right = door_right
	room_instance.door_down = door_down
	room_instance.door_left = door_left
	_room_array[x][y] = [door_up, door_right, door_down, door_left]
	room_instance.enable_collision(true)
	$Rooms.add_child_below_node($Rooms/TileMap, room_instance)
	room_instance.position.x = x * 48
	room_instance.position.y = y * 48


func _spawn_detective() -> void:
	var npc_instance := NPC_SCENE.instance()
	$Rooms.add_child_below_node($Rooms/Spawn, npc_instance)
	npc_instance.position = $Rooms/Spawn.position
	npc_instance.ai_state = npc_instance.AI.Wander
	npc_instance.direction = Vector2.UP


func _attempt_place_room(global_pos: Vector2) -> bool:
	var pos: Vector2 = $Rooms.to_local(global_pos)
	var x := int(pos.x / 48)
	var y := int(pos.y / 48)
	if _room_array[x][y].has(true):
		return false

	var adjacent_door := false
	if $NextRoom/Room.door_up and _room_array[x][y - 1][2]:
		adjacent_door = true
	if $NextRoom/Room.door_right and _room_array[x + 1][y][3]:
		adjacent_door = true
	if $NextRoom/Room.door_down and _room_array[x][y + 1][0]:
		adjacent_door = true
	if $NextRoom/Room.door_left and _room_array[x - 1][y][1]:
		adjacent_door = true
	if !adjacent_door:
		return false

	_add_room(int(pos.x / 48),
			  int(pos.y / 48),
			  $NextRoom/Room.door_up,
			  $NextRoom/Room.door_right,
			  $NextRoom/Room.door_down,
			  $NextRoom/Room.door_left)
	return true


func _new_next_room() -> void:
	var random_doors := []
	while !random_doors.has(true):
		random_doors = [bool(randi() % 2), bool(randi() % 2), bool(randi() % 2), bool(randi() % 2)]
	$NextRoom/Room.door_up = random_doors[0]
	$NextRoom/Room.door_right = random_doors[1]
	$NextRoom/Room.door_down = random_doors[2]
	$NextRoom/Room.door_left = random_doors[3]
	


func _on_NextRoom_button_down():
	_is_holding_next_room = true
	set_process(true)


func _on_NextRoom_button_up():
	_is_holding_next_room = false
	if _attempt_place_room(get_global_mouse_position()):
		_new_next_room()
	$NextRoom.rect_position = Vector2.ZERO
	set_process(false)


func _process(delta):
	$NextRoom.rect_global_position = get_global_mouse_position() - $NextRoom.rect_size / 2


func _ready() -> void:
	set_process(false)
	_room_array = []
	for x in range(_WIDTH):
		_room_array.append([])
		for y in range(_HEIGHT):
			_room_array[x].append([false, false, false, false])
			if $Rooms/TileMap.get_cell(x, y) == 1:
				_add_room(x, y, false, true, true, true)


func _on_DetectiveSpawner_timeout():
	_spawn_detective()
