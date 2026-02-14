extends Area2D

@export var boss : Enemy
@export var next_level : PackedScene

func _ready() -> void:
	GlobalSignals.OnDefeatEnemy.connect(_on_defeat_enemy)
	visible = false
	$CollisionShape2D.disabled = true
	
func _on_defeat_enemy(enemy : Enemy):
	if enemy != boss:
		return
	visible = true
	$CollisionShape2D.set_deffered("disabled", false)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
		
	get_tree().change_scene_to_packed.call_deferred(next_level)
