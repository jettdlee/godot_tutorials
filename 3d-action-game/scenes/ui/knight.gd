extends Node3D

func add_equipment(data):
	var slot = {
		'weapon':$Rig/Skeleton3D/RightHand,
		'shield': $Rig/Skeleton3D/LeftHand,
		'style': $Rig/Skeleton3D/Head
	}[data['type']]
	for child in slot.get_children():
		child.queue_free()
	var item_instance = data['scene'].instantiate()
	slot.add_child(item_instance)

func unequip():
	for child in $Rig/Skeleton3D/Head.get_children():
		child.queue_free()
