extends Control

@onready var player = get_tree().get_first_node_in_group('Player')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.set_loops()
	tween.tween_property($FishRect, "offset_left", 100, 1)
	tween.tween_property($FishRect, "offset_left", -60, 1)

func get_fish() -> bool:
	if abs($FishRect.offset_left) < 40:
		player.get_resource(Global.Resources.FISH, 1)
		return true
	else:
		return false
