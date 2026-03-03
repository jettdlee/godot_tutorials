extends Area2D

signal change_door(grid_coord: Vector2i, open: bool)
var door_coord: Vector2i

func setup(pos: Vector2i):
	door_coord = pos
	position = Vector2(pos.x * Global.TILE_SIZE + Global.TILE_SIZE/2.0, pos.y * Global.TILE_SIZE + Global.TILE_SIZE/2.0)

func _on_body_entered(_body: Node2D) -> void:
	change_door.emit(door_coord, true)

func _on_body_exited(_body: Node2D) -> void:
	change_door.emit(door_coord, false)
