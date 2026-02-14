extends GridContainer

var room_gen : RoomGeneration 
var icons : Array[TextureRect]

var room_texture : Texture = preload("res://Sprites/Items/minimap_room.tres")
var player_room_texture : Texture = preload("res://Sprites/Items/minimap_player_room.tres")

func _ready() -> void:
	GlobalSignals.OnPlaterEnterRoom.connect(_on_player_enter_room)
	
func _on_player_enter_room(room : Room):
	if not room_gen:
		room_gen = get_tree().current_scene.get_node("RoomGeneration")
		
		for child in get_children():
			if child is TextureRect:
				icons.append(child)

	for x in range(room_gen.map_size):
		for y in range(room_gen.map_size):
			var r = room_gen.get_room_from_map(x, y)
			var i = x + y * room_gen.map_size
			
			if i >= len(icons):
				continue
			
			if not r:
				icons[i].texture = null
			elif r == room:
				icons[i].texture = player_room_texture
			else:
				icons[i].texture = room_texture
