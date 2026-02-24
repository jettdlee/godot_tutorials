extends StaticBody2D

func _ready() -> void:
	$Sprite.frame = [0, 1].pick_random()
