extends Node2D

var current_grid_coord: Vector2i
var current_object: Global.Objects = Global.Objects.WALLS
@export var grid_offset: Vector2i = Vector2i(2,0)
@onready var player = get_tree().get_first_node_in_group('Player')

signal build(pos: Vector2i, object: Global.Objects)
signal delete(pos: Vector2i)

func _input(_event: InputEvent) -> void:
	if player.building:
		var direction: Vector2i = Input.get_vector("left","right", "up", 'down')
		current_grid_coord += direction
		position = current_grid_coord * Global.TILE_SIZE
		
		if Input.is_action_just_pressed("action"):
			if player.resources[Global.Resources.WOOD] >= 1:
				build.emit(current_grid_coord, current_object)
				player.get_resource(Global.Resources.WOOD, -1)
				
		if Input.is_action_just_pressed('ui_text_backspace'):
			delete.emit(current_grid_coord)
			
		if Input.is_action_just_pressed('ui_cancel'):
			player.building = false
			player.can_move = true
			hide()
			get_tree().get_first_node_in_group('Resource UI')._tween_animation(1.15)
	
		if Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward"):
			var toggle_direction = int(Input.get_axis("tool_backward", "tool_forward"))
			current_object = posmod(current_object + toggle_direction, Global.Objects.size()) as Global.Objects
			$PreviewSprite.frame = int(current_object)

func reveal(pos: Vector2):
	show()
	current_grid_coord = Vector2i(
		int(pos.x / Global.TILE_SIZE),
		int(pos.y / Global.TILE_SIZE)
	) + grid_offset
	position = current_grid_coord * Global.TILE_SIZE
