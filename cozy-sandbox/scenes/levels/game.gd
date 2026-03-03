extends Node2D

@export var daytime_gradient : Gradient
@export var music_curve : Curve

var plant_scene = preload("res://scenes/levels/plant.tscn")
var blob_scene = preload("res://scenes/characters/blob.tscn")
var object_scene = preload("res://scenes/levels/object.tscn")
var door_checker_scene = preload("res://scenes/levels/door_checker.tscn")

var raining := false:
	set(value):
		raining = value
		if raining:
			$Overlay/RainParticles.emitting = true
			$Layers/FloorRainParticles.emitting = true
			$RainMusic.play()
		else:
			$Overlay/RainParticles.emitting = false
			$Layers/FloorRainParticles.emitting = false
			$RainMusic.stop()

func _process(_delta: float) -> void:
	var daytime_point =  1.0 - ($DayTimer.time_left / $DayTimer.wait_time)
	$CanvasModulate.color = daytime_gradient.sample(daytime_point)
	$Music.volume_db = music_curve.sample(daytime_point)
	
	if Input.is_action_just_pressed("ui_focus_next"):
		day_restart()
		
func day_restart():
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/DayTransition.material, "shader_parameter/progress", 1.0, 1.0)
	tween.tween_interval(0.5)
	tween.tween_callback(reset_level)
	tween.tween_property($CanvasLayer/DayTransition.material, "shader_parameter/progress", 0.0, 1.0)

func reset_level():
	$DayTimer.start()
	$Music.play()
	
	for plant in get_tree().get_nodes_in_group('Plants'):
		plant.grow(plant.soil_grid_cell in $Layers/SoilWaterLayer.get_used_cells())
	
	$Layers/SoilWaterLayer.clear()
	raining = bool(randi_range(0, 1))
	if raining:
		for cell in $Layers/SoilLayer.get_used_cells():
			$Layers/SoilWaterLayer.set_cell(cell, 0, Vector2i(randi_range(0,2),0))
	for tree in get_tree().get_nodes_in_group('Trees'):
		tree.reset()


func _on_player_tool_interact(tool: int, pos: Vector2) -> void:
	var grid_coord = Vector2i(int(pos.x/Global.TILE_SIZE),int(pos.y/Global.TILE_SIZE))
	match tool:
		Global.Tools.AXE:
			for tree in get_tree().get_nodes_in_group("Trees"):
				if tree.position.distance_to(pos) < 16:
					tree.health -= 1
					tree.get_apple()
					tree.cut()
		Global.Tools.SWORD:
			for blob in get_tree().get_nodes_in_group('Blobs'):
				if blob.position.distance_to(pos) < 14:
					blob.flash()
					blob.push()
					blob.health -= 1
		Global.Tools.FISH:
			if not $Layers/WaterLayer.get_cell_tile_data(grid_coord):
				await get_tree().create_timer(0.5).timeout
				$Objects/Player.stop_fishing()
		Global.Tools.HOE:
			var cell = $Layers/GrassLayer.get_cell_tile_data(grid_coord) as TileData
			if cell and cell.get_custom_data('farmable'):
				$Layers/SoilLayer.set_cells_terrain_connect([grid_coord], 0, 0)
			if raining:
				$Layers/SoilWaterLayer.set_cell(grid_coord, 0, Vector2i(randi_range(0,2),0))
		Global.Tools.WATER:
			var cell = $Layers/SoilLayer.get_cell_tile_data(grid_coord) as TileData
			if cell:
				$Layers/SoilWaterLayer.set_cell(grid_coord, 0, Vector2i(randi_range(0,2),0))
	

func _on_blob_spawn_timer_timeout() -> void:
	var blob = blob_scene.instantiate()
	$Objects.add_child(blob)
	blob.position = $BlobSpawnPositions.get_children().pick_random()

func _on_player_seed_interact(seed_enum: int, pos: Vector2) -> void:
	var grid_coord = Vector2i(int(pos.x/Global.TILE_SIZE),int(pos.y/Global.TILE_SIZE))
	var soil_cell = $Layers/SoilLayer.get_cell_tile_data(grid_coord) as TileData
	var existing_plant_cells = []
	for plant in get_tree().get_nodes_in_group('Plants'):
		existing_plant_cells.append(plant.soil_grid_cell)
	if soil_cell and grid_coord not in existing_plant_cells:
		var plant_pos = Vector2(
			grid_coord.x * Global.TILE_SIZE + Global.TILE_SIZE/2.0,
			grid_coord.y * Global.TILE_SIZE - 4)
		var plant = plant_scene.instantiate()
		$Objects.add_child(plant)
		plant.position = plant_pos
		plant.setup(seed_enum, grid_coord)


func _on_player_build_mode() -> void:
	$DayTimer.paused = true
	$Overlay/BuildOverlay.reveal($Objects/Player.position)
	$CanvasLayer/ResourceUI._tween_animation(1.0)


func _on_build_overlay_build(pos: Vector2i, object: int) -> void:
	if object == Global.Objects.WALLS:
		$Objects/WallsLayer.set_cells_terrain_connect([pos],0,0)
		$Layers/HouseFloorLayer.set_cell(pos, 0, Vector2i.ZERO)
	
	if object == Global.Objects.DOOR:
		var current_cell = $Objects/WallsLayer.get_cell_tile_data(pos) as TileData
		if current_cell and current_cell.get_custom_data('CanDoor'):
			if not current_cell.get_custom_data('Door'):
				$Objects/WallsLayer.set_cell(pos, 0, Vector2i(0,4))
				var door_checker = door_checker_scene.instantiate()
				$Objects.add_child(door_checker)
				door_checker.setup(pos)
				door_checker.connect('change_door', door_handler)
	
	if object not in [Global.Objects.WALLS, Global.Objects.DOOR]:
		for obj in get_tree().get_nodes_in_group('Objects'):
			if obj.can_delete(pos):
				obj.queue_free()
		var object_instance = object_scene.instantiate() as StaticBody2D
		object_instance.setup(object)
		var target_group = $Layers/CarpetLayer if object == Global.Objects.CARPET else $Objects
		target_group.add_child(object_instance)
		object_instance.position = pos * Global.TILE_SIZE + Vector2i(8, 8)

func _on_build_overlay_delete(pos: Vector2i) -> void:
	for object in get_tree().get_nodes_in_group('Objects'):
		if object.can_delete(pos):
			object.queue_free()
			return
			
	var tile_data =  $Objects/WallsLayer.get_cell_tile_data(pos) as TileData
	if tile_data and tile_data.get_custom_data('Door'):
		for door_checker in get_tree().get_nodes_in_group('Door Checker'):
			if door_checker.door_coord == pos:
				door_checker.queue_free()
				$Objects/WallsLayer.set_cells_terrain_connect([pos],0,0)
				$Layers/HouseFloorLayer.set_cell(pos, 0, Vector2i.ZERO)
				return
	
	$Objects/WallsLayer.set_cells_terrain_connect([pos],0,-1)
	$Layers/HouseFloorLayer.erase_cell(pos)

func door_handler(door_coord: Vector2i, open: bool):
	$Objects/WallsLayer.set_cell(door_coord, 0, Vector2i(1,1) if open else Vector2(0,4))
