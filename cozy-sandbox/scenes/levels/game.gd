extends Node2D

@export var daytime_gradient : Gradient
@export var music_curve : Curve

var blob_scene = preload("res://scenes/characters/blob.tscn")

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
	for tree in get_tree().get_nodes_in_group('Trees'):
		tree.reset()


func _on_player_tool_interact(tool: int, pos: Vector2) -> void:
	var grid_coord = Vector2i(int(pos.x/Global.TILE_SIZE),int(pos.y/Global.TILE_SIZE))
	if tool == Global.Tools.AXE:
		for tree in get_tree().get_nodes_in_group("Trees"):
			if tree.position.distance_to(pos) < 16:
				tree.health -= 1
				tree.get_apple()
				tree.cut()
	
	if tool == Global.Tools.SWORD:
		for blob in get_tree().get_nodes_in_group('Blobs'):
			if blob.position.distance_to(pos) < 14:
				blob.flash()
				blob.push()
				blob.health -= 1

	if tool == Global.Tools.FISH:
		if not $Layers/WaterLayer.get_cell_tile_data(grid_coord):
			await get_tree().create_timer(0.5).timeout
			$Objects/Player.stop_fishing()

func _on_blob_spawn_timer_timeout() -> void:
	var blob = blob_scene.instantiate()
	$Objects.add_child(blob)
	blob.position = $BlobSpawnPositions.get_children().pick_random()
