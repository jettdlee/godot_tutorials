class_name Character
extends CharacterBody3D

@export var base_speed : float = 4
@export var run_speed: float = 6
@export var defend_speed: float = 2
var movement_input: Vector2

@export var jump_height: float = 2.25
@export var jump_time_to_peak: float = 0.4
@export var jump_time_to_descent: float = 0.3

@onready var jump_velocity: float = (2.0 * jump_height) / jump_time_to_peak * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@onready var move_state_machine = $AnimationTree.get('parameters/MoveStateMachine/playback') as AnimationNodeStateMachinePlayback
@onready var attack_animation = $AnimationTree.get_tree_root().get_node('AttackAnimation') as AnimationNodeAnimation 

var skin: Node3D
var attacking: bool = false
var defending: bool = false:
	set(value):
		if not defending and value:
			defend_toggle(true)
		if defending and not value:
			defend_toggle(false)
		defending = value

var current_weapon
var current_shield
var squash_and_stretch: float = 1.0:
	set(value):
		squash_and_stretch = value
		var negative = 1.0 + (1.0 - squash_and_stretch)
		skin.scale = Vector3(negative, squash_and_stretch, negative)
var health: int = 5

func defend_toggle(forward: bool):
	var tween = create_tween()
	tween.tween_method(_defend_change, 1.0 - float(forward), float(forward), 0.25)
	
func _defend_change(value):
	$AnimationTree.set("parameters/DefendBlend/blend_amount", value)
	
func apply_gravity(gravity, delta):
	velocity.y -= gravity * delta
	
func set_move_state(state_name: String):
	move_state_machine.travel(state_name)

func equip(data, slot):
	for child in slot.get_children():
		child.queue_free()
	var item_scene = data['scene'].instantiate()
	slot.add_child(item_scene)
	if data['type'] == 'weapon':
		item_scene.setup(data['animation'], data['damage'], data['range'], self)
		attack_animation.animation = data['animation']
		current_weapon = item_scene
		current_weapon.set_sound(data['audio'])
	if data['type'] == 'shield':
		item_scene.defense = data['defense']
		current_shield = item_scene

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if 'Attack' in anim_name:
		attacking = false

func attack_logic():
	if attacking:
		var collider = current_weapon.get_collider()
		if collider and collider != self and 'hit' in collider:
			collider.hit(current_weapon)
			
func hit(attacking_weapon):
	if not $Timers/HitTimer.time_left:
		if current_shield and defending:
			health -= attacking_weapon.damage * current_shield.defense
			current_shield.flash()
			current_shield.play_audio()
		else:
			health -= attacking_weapon.damage
			$HitSound.play()
		$Timers/HitTimer.start()
		do_squash_and_stretch(1.2, 0.2)
		
		if health <= 0:
			death_logic()
			
func death_logic():
	pass
		
func do_squash_and_stretch(value: float, duration: float):
	var tween = create_tween()
	tween.tween_property(self, "squash_and_stretch", value, duration)
	tween.tween_property(self, "squash_and_stretch", 1.0, duration * 1.8).set_ease(Tween.EASE_OUT)
