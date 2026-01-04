extends Camera2D

func _ready() -> void:
	GlobalSignals.OnPlaterEnterRoom.connect(_on_player_enter_room)

func _on_player_enter_room(room : Room):
	global_position = room.global_position
