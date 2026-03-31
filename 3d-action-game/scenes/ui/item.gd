extends Button

@onready var player_preview = get_tree().get_first_node_in_group("PlayerPreview")
@onready var player = get_tree().get_first_node_in_group("Player")
var equipment_data


func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL


func setup(data):
	$TextureRect.texture = data['thumbnail']
	equipment_data = data


func _on_resized() -> void:
	custom_minimum_size.y = get_rect().size.x


func highlight(value: bool):
	if value:
		$EquippedPanel.show()
	else:
		$EquippedPanel.hide()


func _on_pressed() -> void:
	# update the real player
	var slot = {'weapon': 'RightHand', 'shield': 'LeftHand', 'style': 'Head'}[equipment_data['type']]
	player.equip(equipment_data, player.get_node('PlayerSkin/Rogue/Rig/Skeleton3D/' + slot))
	
	#update the preview
	player_preview.add_equipment(equipment_data)
	for item in get_parent().get_children():
		item.highlight(false)
	highlight(true)
