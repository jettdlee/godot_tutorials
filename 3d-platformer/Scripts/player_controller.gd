extends CharacterBody3D

signal OnTakeDamage (hp : int)
signal OnIncreaseScore (score : int)

@export var move_speed : float = 3.0
@export var jump_force : float = 8.0
@export var gravity : float = 20.0
@export var health : int = 3

@onready var camera : Camera3D = $Camera3D
@onready var audio : AudioStreamPlayer3D = $AudioStreamPlayer3D

var coin_sfx : AudioStream = preload("res://Assets/Audio/coin.wav")
var take_damage_sfx : AudioStream = preload("res://Assets/Audio/take_damage.wav")

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
	OnTakeDamage.emit(health)
	_play_sound(take_damage_sfx)
	if health <= 0:
		call_deferred("_game_over")
	
func _game_over():
	PlayerStats.score = 0
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
func increase_score(amount : int):
	PlayerStats.score += amount
	OnIncreaseScore.emit(PlayerStats.score)
	_play_sound(coin_sfx)

func _play_sound(sound : AudioStream):
	audio.stream = sound
	audio.play()
