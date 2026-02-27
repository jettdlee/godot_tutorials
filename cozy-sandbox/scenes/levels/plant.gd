extends StaticBody2D

var soil_grid_cell: Vector2i
var age : float
var max_age: int
var grow_speed: float

const  plant_data = {
	Global.Seeds.CORN: {
		'texture': preload("res://graphics/ui/corn.png"), 
		'grow_speed': 0.6,
		'max_age': 3
	},
	Global.Seeds.TOMATO: {
		'texture': preload("res://graphics/ui/tomato.png"),
		'grow_speed': 0.8,
		'max_age': 3
		},
	Global.Seeds.PUMPKIN: { 
		'texture': preload("res://graphics/ui/pumpkin.png"),
		'grow_speed': 0.4,
		'max_age': 3
	}
}

func setup(seed_enum: Global.Seeds, grid_coords: Vector2i):
	soil_grid_cell = grid_coords
	$Sprite2D.texture = plant_data[seed_enum]['texture']
	max_age = plant_data[seed_enum]['max_age']
	grow_speed = plant_data[seed_enum]['grow_speed']

func grow(watered: bool):
	if watered:
		age = min(age + grow_speed, max_age)
		$Sprite2D.frame = int(age)

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if age == max_age:
		queue_free()
