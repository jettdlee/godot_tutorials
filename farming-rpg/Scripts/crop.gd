class_name Crop
extends Node2D

var crop_data : CropData
var days_until_grown : int
var watered : bool
var harvestable : bool
var tile_map_coords : Vector2i

@onready var sprite : Sprite2D = $Sprite2D

func _ready() -> void:
	pass
	
func set_crop(data: CropData, already_watered: bool, tile_coords: Vector2i):
	crop_data = data
	watered = already_watered
	tile_map_coords = tile_coords
	harvestable = false
	
	days_until_grown = data.days_to_grow
	sprite.texture = crop_data.growth_sprites[0]
	
func _on_new_day (day : int):
	pass
