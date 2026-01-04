extends CharacterBody2D

@export var current_hp : int = 4
@export var max_hp : int = 4
@export var move_speed : float = 20

@export var attack_damage : int = 1
@export var attack_range : float = 10
@export var attack_rate : float = 0.5

var last_attack_time : float

@onready var sprite : Sprite2D = $Sprite

var room : Room
var is_active : bool = false
var player : CharacterBody2D

var player_direction : Vector2
var player_distance : float

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
func initialize(in_room : Room):
	pass
	
func _on_player_enter_room(player_room : Room):
	pass
	
func _physics_process(delta: float) -> void:
	player_direction = global_position.direction_to(player.global_position)
	player_distance = global_position.distance_to(player.global_position)
	sprite.flip_h = player_direction.x < 0
	
	velocity = player_direction * move_speed
	move_and_slide()
	
func _try_attack():
	pass
	
func take_damage(damage : int):
	pass
	
func die():
	pass
