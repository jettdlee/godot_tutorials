extends Control

@onready var player = get_tree().get_first_node_in_group('Player')

func _ready() -> void:
	update_resources()
	$HBoxContainer.anchor_bottom = 1.15
	$HBoxContainer.anchor_top = 1.15
	
func update_resources():
	for resource in player.resources:
		$HBoxContainer.get_child(resource).get_child(0).text = str(player.resources[resource])
	_tween_animation(1.0)
	$Timer.start()

func _on_timer_timeout() -> void:
	_tween_animation(1.15)

func _tween_animation(target: float):
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property($HBoxContainer, 'anchor_bottom', target, 0.5)
	tween.tween_property($HBoxContainer, 'anchor_top', target, 0.5)
