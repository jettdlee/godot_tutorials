extends Character

@onready var player = get_tree().get_first_node_in_group('Player')
@export var notice_radius: float = 30
@export var speed: float = 3

func _ready() -> void:
	for child in $Skins.get_children():
		child.hide()
	var skin = $Skins.get_children().pick_random()
	skin.show()
	$AnimationTree.anim_player = "../Skins/" + skin.name + '/AnimationPlayer'
	var random_weapon = Global.weapons[Global.weapons.keys().pick_random()]
	equip(random_weapon, skin.get_node('Rig/Skeleton3D/RightHand'))

func _physics_process(delta: float) -> void:
	move_to_player(delta)
	move_and_slide()
	
func move_to_player(delta):
	if position.distance_to(player.position) < notice_radius:
		var target_dir = (player.position - position).normalized()
		var target_vec2 = Vector2(target_dir.x, target_dir.z)

		var target_angle = -target_vec2.angle() + PI/2
		rotation.y = rotate_toward(rotation.y, target_angle, delta * 6)
		velocity = Vector3(target_vec2.x, 0, target_vec2.y) * speed
		set_move_state('Running_A')
