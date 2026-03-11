extends Character

@export var acceleration: float = 8
@export var deceleration: float = 8
@onready var camera = $CameraController/Camera3D

var weapons = [Global.weapons['sword'], Global.weapons['dagger'], Global.weapons['staff']]
var weapon_index: int
var shields = [Global.shields['square'], Global.shields['round'], Global.shields['spike']]
var shield_index: int
var styles = [Global.style['duckhat']]
var style_index: int

func _ready() -> void:
	skin = $PlayerSkin
	equip(weapons[weapon_index], $PlayerSkin/Knight/Rig/Skeleton3D/RightHand)
	equip(shields[shield_index], $PlayerSkin/Knight/Rig/Skeleton3D/LeftHand)
	equip(styles[style_index], $PlayerSkin/Knight/Rig/Skeleton3D/Head)

func _physics_process(delta: float) -> void:
	move_logic(delta)
	jump_logic(delta)
	ability_logic()
	move_and_slide()
	attack_logic()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed('switch_weapon'):
		weapon_index = posmod(weapon_index + 1, weapons.size())
		equip(weapons[weapon_index], $PlayerSkin/Knight/Rig/Skeleton3D/RightHand)
	if Input.is_action_just_pressed('switch_shield'):
		shield_index = posmod(shield_index + 1, shields.size())
		equip(shields[shield_index], $PlayerSkin/Knight/Rig/Skeleton3D/LeftHand)

func move_logic(delta: float):
	movement_input = Input.get_vector('left','right', 'forward','backward').rotated(-camera.global_rotation.y)
	var velocity_2d = Vector2(velocity.x, velocity.z)
	
	if movement_input != Vector2.ZERO:
		var speed = run_speed if Input.is_action_pressed('run') else base_speed
		speed = defend_speed if defending else base_speed
		velocity_2d += movement_input * speed * delta * acceleration
		velocity_2d = velocity_2d.limit_length(base_speed)
		var target_angle = -movement_input.angle() + PI/2
		skin.rotation.y = rotate_toward(skin.rotation.y, target_angle, delta * 6)
		set_move_state('Running_A')
	else:
		velocity_2d = velocity_2d.move_toward(Vector2.ZERO, base_speed * delta * deceleration)
		set_move_state('Idle')

	velocity.x = velocity_2d.x
	velocity.z = velocity_2d.y

func jump_logic(delta):
	if is_on_floor():
		if Input.is_action_just_pressed('jump'):
			velocity.y = -jump_velocity
	else:
		set_move_state('Jump_Idle')
	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	apply_gravity(gravity, delta)
	current_weapon.play_audio()

func ability_logic():
	if Input.is_action_just_pressed("attack"):
		if not attacking:
			$AnimationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			attacking = true
	defending = Input.is_action_pressed("defend")

func death_logic():
	get_tree().quit()
