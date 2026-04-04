extends CanvasLayer

func _ready() -> void:
	$ColorRect.modulate = Color(0,0)

func change_scene(target_path: String):
	var tween = create_tween()
	tween.tween_property($ColorRect, 'modulate', Color(0,1), 0.5)
	tween.tween_callback(Callable(self, 'open_scene').bind(target_path))
	tween.tween_property($ColorRect, 'modulate', Color(0,0), 0.5)
	
func open_scene(path):
	get_tree().change_scene_to_file(path)
