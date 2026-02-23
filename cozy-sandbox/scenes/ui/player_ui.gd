extends Node2D

func _ready() -> void:
	$Tools.visible = false
	
func reveal(current_tool: Global.Tools):
	$Tools/Main.frame = int(current_tool)
	$Tools/Left.frame = posmod(int(current_tool) - 1, Global.Tools.size())
	$Tools/Right.frame = posmod(int(current_tool) + 1, Global.Tools.size())
	
	$Tools.show()
	$Timer.start()
	
func _on_timer_timeout() -> void:
	$Tools.visible = false
