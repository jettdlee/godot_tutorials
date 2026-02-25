extends Node2D

@export var daytime_gradient : Gradient
@export var music_curve : Curve


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
	if tool == Global.Tools.AXE:
		for tree in get_tree().get_nodes_in_group("Trees"):
			if tree.position.distance_to(pos) < 16:
				tree.health -= 1
				tree.get_apple()
				tree.cut()
