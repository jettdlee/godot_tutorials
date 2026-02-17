extends Area2D

@export var speed : float = 200.0
@export var owner_group : String
@onready var destroy_timer : Timer = $DestroyTimer

var move_dir : Vector2

func _process(delta: float) -> void:
	translate(move_dir * speed * delta)
	rotation = move_dir.angle()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		return
	
func _on_destroy_timer_timeout() -> void:
	visible = false

func _on_visibility_changed() -> void:
	if visible == true and destroy_timer:
		destroy_timer.start()
