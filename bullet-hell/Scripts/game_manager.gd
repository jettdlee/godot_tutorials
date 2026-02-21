extends Node2D

var elapsed_time : float

@onready var elapsed_time_text : Label = $CanvasLayer/ElapsedTimeText
@onready var end_screen = $CanvasLayer/EndScreen
@onready var end_text : Label = $CanvasLayer/EndScreen/EndText

func _process(delta: float) -> void:
	elapsed_time += delta
	elapsed_time_text.text = str("%.1f" % elapsed_time)
	
func set_game_over():
	Engine.time_scale = 0.0
	end_screen.visible = true
	end_text.text = "Survived for " + str("%.1f" % elapsed_time) + " seconds"

func _on_button_pressed() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
