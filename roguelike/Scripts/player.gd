extends CharacterBody2D

@export var move_speed : float = 50

@onready var sprite : Sprite2D = $Sprite
@onready var weapon_origin : Node2D = $Weapon
@onready var muzzle : Node2D = $Weapon/Muzzle

func _physics_process(delta: float) -> void:
	var move_input : Vector2 = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = move_input * move_speed
	move_and_slide()

func _process(delta: float) -> void:
	var mouse_pos : Vector2 = get_global_mouse_position()
	var mouse_dir : Vector2 = (mouse_pos - global_position).normalized()
	weapon_origin.rotation_degrees = rad_to_deg(mouse_dir.angle()) + 90
	
	sprite.flip_h = mouse_dir.x < 0
