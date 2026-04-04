extends Area3D

@export_enum('Castle', 'Overworld') var target = 'Overworld'
var targets = {
	'Castle': "res://scenes/levels/castle.tscn",
	'Overworld': "res://scenes/levels/overworld.tscn"
}

func _on_body_entered(_body: Node3D) -> void:
	TransitionLayer.change_scene(targets[target])
