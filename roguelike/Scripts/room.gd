class_name Room
extends StaticBody2D

enum Direction {
	NORTH,
	SOUTH,
	EAST,
	WEST
}

@export var doors_always_open : bool = false

@onready var entrance_north : RoomEntrance = $EntranceNorth
@onready var entrance_south : RoomEntrance = $EntranceSouth
@onready var entrance_east : RoomEntrance = $EntranceEast
@onready var entrance_west : RoomEntrance = $EntranceWest

var enemies_in_room : int

func _ready() -> void:
	pass
	
func initialize():
	pass

func set_neighbour(neighbour_direction : Direction, neighbour_room : Room):
	if neighbour_direction == Direction.NORTH:
		entrance_north.set_neighbour(neighbour_room)
	elif neighbour_direction == Direction.SOUTH:
		entrance_south.set_neighbour(neighbour_room)
	elif neighbour_direction == Direction.EAST:
		entrance_east.set_neighbour(neighbour_room)
	elif neighbour_direction == Direction.WEST:
		entrance_west.set_neighbour(neighbour_room)

func _player_enter(entry_direction : Direction, player : CharacterBody2D, first_room : bool = false):
	if entry_direction == Direction.NORTH:
		player.global_position = entrance_north.player_spawn.global_position
	elif entry_direction == Direction.SOUTH:
		player.global_position = entrance_south.player_spawn.global_position
	elif entry_direction == Direction.EAST:
		player.global_position = entrance_east.player_spawn.global_position
	elif entry_direction == Direction.WEST:
		player.global_position = entrance_west.player_spawn.global_position
	
	if first_room:
		player.global_position = global_position
		
	GlobalSignals.OnPlaterEnterRoom.emit(self)
	
	if enemies_in_room > 0 and not doors_always_open:
		close_doors()
	else:
		open_doors()
	
func _on_defeat_enemy(enemy):
	pass

func open_doors():
	entrance_north.open_door()
	entrance_east.open_door()
	entrance_south.open_door()
	entrance_west.open_door()
	
func close_doors():
	entrance_north.close_door()
	entrance_east.close_door()
	entrance_south.close_door()
	entrance_west.close_door()
