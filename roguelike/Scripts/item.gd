extends Area2D

enum ItemType
{
	HEALTH,
	SHOOT_RATE,
	MOVE_SPEED
}

@export var type : ItemType
@export var value : float

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	if type == ItemType.HEALTH:
		body.heal(int(value))
	elif type == ItemType.SHOOT_RATE:
		body.shoot_rate -= value
	elif type == ItemType.MOVE_SPEED:
		body.move_speed += value
	
	body.get_node("ItemSound").play()
	queue_free()
	
