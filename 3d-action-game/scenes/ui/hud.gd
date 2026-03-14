extends Control

var heart_scene = preload('res://scenes/ui/heart.tscn')

func setup(hearts: int):
	for heart in hearts:
		var heart_instance = heart_scene.instantiate()
		$Hearts.add_child(heart_instance)

func set_health(health: int):
	for child in $Hearts.get_children():
		child.queue_free()
	setup(health)
