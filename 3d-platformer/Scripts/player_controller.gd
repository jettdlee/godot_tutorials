extends CharacterBody3D

@export var move_speed : float = 3.0
@export var jump_force : float = 8.0
@export var gravity : float = 20.0
@export var health : int = 3

@onready var camera : Camera3D = $Camera3D

func _physics_process(delta: float) -> void:
	set_gravity(delta)
	jump_action()
	movement_controls()
	move_and_slide()

func _process(delta: float) -> void:
	if global_position.y < -5:
		_game_over()

func movement_controls():
	var move_input : Vector2 = -Input.get_vector("move_right","move_left","move_back","move_forward")
	var move_direction : Vector3 = Vector3(move_input.x, 0, move_input.y) * move_speed
	velocity.x = move_direction.x
	velocity.z = move_direction.z
	
func set_gravity(delta):
	velocity.y -= gravity * delta

func jump_action():
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_force

func take_damage(amount : int):
	health -= amount
	if health <= 0:
		_game_over()
	
func _game_over():
	get_tree().reload_current_scene()
