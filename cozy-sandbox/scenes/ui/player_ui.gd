extends Node2D

func _ready() -> void:
	$Tools.hide()
	$Seed.hide()
	
func reveal(current_tool: Global.Tools):
	$Seed.hide()
	$Tools/Main.frame = int(current_tool)
	$Tools/Left.frame = posmod(int(current_tool) - 1, Global.Tools.size())
	$Tools/Right.frame = posmod(int(current_tool) + 1, Global.Tools.size())
	
	$Tools.show()
	$Timer.start()
	
func _on_timer_timeout() -> void:
	$Tools.hide()
	$Seed.hide()

func show_seed(current_seed: Global.Seeds):
	$Timer.start()
	$Tools.hide()
	$Seed.show()
	$Seed.frame = int(current_seed)
