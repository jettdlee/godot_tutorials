extends InteractableObject

@onready var light_bulb = $LightBulb

func _interact():
	light_bulb.visible = true
	can_interact = false
