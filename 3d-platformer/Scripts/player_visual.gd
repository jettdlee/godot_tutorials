extends MeshInstance3D

@export var rotation_rate : float = 20.0
var target_y_rotation : float = 0

@onready var player : CharacterBody3D = get_parent()

func _process(delta: float) -> void:
	_smooth_rotation(delta)
	_move_bob(delta)

func _smooth_rotation(delta):
	var velocity = -player.velocity
	if velocity.x != 0 or velocity.z != 0:
		target_y_rotation = atan2(velocity.x, velocity.z)
	rotation.y = lerp_angle(rotation.y, target_y_rotation, rotation_rate * delta)
	
func _move_bob(delta):
	var move_speed = player.velocity.length()
	if move_speed < 0.1 or not player.is_on_floor():
		scale.y = 1
		return
		
	var time = Time.get_unix_time_from_system()
	var y_scale = 1 + (sin(time * 30) * 0.08)
	scale.y = y_scale
	
