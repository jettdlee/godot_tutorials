extends Character

@onready var player = get_tree().get_first_node_in_group('Player')
@export var notice_radius: float = 30
@export var speed: float = 3
var attack_radius: float = 3
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	for child in $Skins.get_children():
		child.hide()
	skin = $Skins.get_children().pick_random()
	skin.show()
	$AnimationTree.anim_player = "../Skins/" + skin.name + '/AnimationPlayer'
	var random_weapon = Global.weapons[Global.weapons.keys().pick_random()]
	equip(random_weapon, skin.get_node('Rig/Skeleton3D/RightHand'))
	attack_radius = current_weapon.radius
	health = 3

func _physics_process(delta: float) -> void:
	if health > 0:
		move_to_player(delta)
		if not is_on_floor():
			apply_gravity(fall_gravity, delta)
		else:
			velocity.y = 0
		move_and_slide()
		attack_logic()
	
func move_to_player(delta):
	if position.distance_to(player.position) < notice_radius:
		var target_dir = (player.position - position).normalized()
		var target_vec2 = Vector2(target_dir.x, target_dir.z)

		var target_angle = -target_vec2.angle() + PI/2
		rotation.y = rotate_toward(rotation.y, target_angle, delta * 6)
		if position.distance_to(player.position) > attack_radius:
			velocity = Vector3(target_vec2.x, 0, target_vec2.y) * speed
			set_move_state('Running_A')
		else:
			velocity = Vector3.ZERO
			set_move_state('Idle')

func _on_attack_timer_timeout() -> void:
	$Timers/AttackTimer.wait_time = rng.randf_range(2.0, 3.5)
	if position.distance_to(player.position) < attack_radius:
		$AnimationTree.set('parameters/AttackOneShot/request', AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		attacking = true

func death_logic():
	$CollisionShape3D.disabled = true
	$Timers/AttackTimer.stop()
	var tween = create_tween()
	tween.tween_method(_death_change, 0.0, 1.0, 0.25)
	
func _death_change(value):
	$AnimationTree.set("parameters/DeathBlend/blend_amount", value)
