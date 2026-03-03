extends StaticBody2D

const collision_sizes = {
	Global.Objects.PLANT: Vector2(8, 15),
	Global.Objects.BED: Vector2(16, 12),
	Global.Objects.SHELF: Vector2(29, 11),
	Global.Objects.TABLE: Vector2(29, 11),
	Global.Objects.CARPET: Vector2(32, 32)
}

func setup(object_enum: Global.Objects):
	$Sprite2D.frame = int(object_enum)
	var collision_shape = RectangleShape2D.new()
	collision_shape.size = collision_sizes[object_enum]
	$CollisionShape2D.shape = collision_shape
	if object_enum == Global.Objects.CARPET:
		$CollisionShape2D.disabled = true

func can_delete(pos: Vector2i) -> bool:
	var shape = Rect2(position, $CollisionShape2D.shape.size)
	return shape.has_point(pos * 16 + Vector2i(8, 8))
