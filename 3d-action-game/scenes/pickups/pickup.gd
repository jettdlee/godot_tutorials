extends Node3D

@export_enum("sword", "staff", "dagger", "axe", "square", "round", "spike", "duckhat", "tophat", "sunglasses", "starglasses") var pickup_type : String

var data: Dictionary

func _ready() -> void:
	for dict in [Global.weapons, Global.shields, Global.style]:
		if pickup_type in dict:
			data = dict[pickup_type]
			add_child(data['scene'].instantiate())

func _physics_process(delta: float) -> void:
	rotate_y(2 * delta)
	position.y += sin(Time.get_ticks_msec() * delta * 0.2) * 0.03

func _on_area_3d_body_entered(player: Node3D) -> void:
	var target = { 'weapon': player.weapons, 'shield': player.shields, 'style': player.styles }[data['type']]
	if data not in target:
		target.append(data)
	var tween = create_tween()
	tween.tween_property(self, 'scale', Vector3(0.1, 0.1, 0.1), 0.5)
	await tween.finished
	queue_free()
