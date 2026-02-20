extends CharacterBody2D

@export var max_speed : float
@export var acceleration : float
@export var drag : float
@export var stop_range: float
@export var shoot_rate : float
@export var shoot_range : float

@onready var avoidance_ray : RayCast2D = $AvoidanceRay
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var sprite : Sprite2D = $Sprite
@onready var bullet_pool = $EnemyBulletPool
@onready var muzzle = $Muzzle


var player_dist : float
var player_dir : Vector2
var last_shoot_time : float

func _process(delta: float) -> void:
	player_dist = global_position.distance_to(player.global_position)
	player_dir = global_position.direction_to(player.global_position)
	sprite.flip_h = player_dir.x < 0
	
	if player_dist < shoot_range:
		if Time.get_unix_time_from_system() - last_shoot_time > shoot_rate:
			_shoot()
	
func _physics_process(delta: float) -> void:
	var move_dir = player_dir
	var local_avoidance = _local_avoidance()
	
	if local_avoidance.length() > 0:
		move_dir = local_avoidance
	
	if velocity.length() < max_speed and player_dist > stop_range:
		velocity += move_dir * acceleration
	else:
		velocity *= drag
		
	move_and_slide()

func _local_avoidance () -> Vector2:
	avoidance_ray.target_position = to_local(player.global_position).normalized()
	avoidance_ray.target_position *= 80
	
	if not avoidance_ray.is_colliding():
		return Vector2.ZERO
	
	var obstacle = avoidance_ray.get_collider()
	
	if obstacle == player:
		return Vector2.ZERO
	
	var obstacle_point =avoidance_ray.get_collision_point()
	var obstacle_dir = global_position.direction_to(obstacle_point)
	return Vector2(-obstacle_dir.y, obstacle_dir.x)

func _shoot():
	last_shoot_time = Time.get_unix_time_from_system()
	
	var bullet = bullet_pool.spawn()
	bullet.global_position = muzzle.global_position
	
	bullet.move_dir = muzzle.global_position.direction_to(player.global_position)
