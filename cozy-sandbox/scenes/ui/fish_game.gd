extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.set_loops()
	tween.tween_property($FishRect, "offset_left", 100, 1)
	tween.tween_property($FishRect, "offset_left", -60, 1)

func get_fish() -> bool:
	if abs($FishRect.offset_left) < 40:
		return true
	else:
		return false
