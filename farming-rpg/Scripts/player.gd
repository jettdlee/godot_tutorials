extends CharacterBody2D

@export var move_speed : float = 30.0
var facing_direction : Vector2

func _ready() -> void:
	facing_direction = Vector2.DOWN
	
func _physics_process(delta: float) -> void:
	var move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if move_input:
		facing_direction = move_input

	velocity = move_input * move_speed
	move_and_slide()
