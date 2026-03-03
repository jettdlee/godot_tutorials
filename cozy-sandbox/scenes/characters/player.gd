extends CharacterBody2D

@onready var move_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var tool_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/ToolStateMachine/playback")
@onready var resource_ui: Control = get_tree().get_first_node_in_group('Resource UI')

const state_names = {
	Global.Tools.HOE: 'hoe',
	Global.Tools.AXE: 'axe',
	Global.Tools.WATER: 'water',
	Global.Tools.SWORD: 'sword',
	Global.Tools.FISH: 'fish'
}

var direction: Vector2
var last_direction: Vector2
@export var speed := 200
@export var tool_offset := 20
var can_move : bool = true
var current_tool: Global.Tools = Global.Tools.HOE
var current_seed: Global.Seeds = Global.Seeds.CORN
var fishing := false
var building := false

signal tool_interact(tool: Global.Tools, pos: Vector2)
signal seed_interact(seed: Global.Seeds, pos: Vector2)
signal build_mode

var resources = {
	Global.Resources.APPLE: 0,
	Global.Resources.WOOD: 0,
	Global.Resources.FISH: 0,
	Global.Resources.TOMATO: 0,
	Global.Resources.CORN: 0,
	Global.Resources.PUMPKIN: 0
}

func _physics_process(_delta: float) -> void:
	if can_move:
		get_input()
		set_animation()
	elif fishing:
		get_fishing_input()
	
	if direction:
		last_direction = direction
		if not $Timers/WalkTimer.time_left:
			$Timers/WalkTimer.start()
	else:
		$Timers/WalkTimer.stop()
	velocity = direction * speed * int(can_move)
	move_and_slide()

func get_input():
	direction = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_just_pressed("action"):
		tool_state_machine.travel(state_names[current_tool])
		$AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		can_move = false
		if current_tool in [Global.Tools.HOE, Global.Tools.WATER]:
			await $AnimationTree.animation_finished
			tool_interact.emit(current_tool, position + last_direction * tool_offset)
		elif current_tool == Global.Tools.FISH:
			fishing = true
			$Timers/FishDelayTimer.start()
			await $AnimationTree.animation_finished
			tool_interact.emit(current_tool, position + last_direction * tool_offset)
			$FishGameContainer/FishGame.show()
	
	if Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward"):
		var toggle_direction = int(Input.get_axis("tool_backward", "tool_forward"))
		current_tool = posmod(current_tool + toggle_direction, Global.Tools.size()) as Global.Tools
		$PlayerUI.reveal(current_tool)
		
	if Input.is_action_just_pressed("seed_toggle"):
		current_seed = posmod(current_seed + 1, Global.Seeds.size()) as Global.Seeds
		$PlayerUI.show_seed(current_seed)
	if Input.is_action_just_pressed("plant"):
		can_move = false
		direction = Vector2.ZERO
		seed_interact.emit(current_seed, position + last_direction * tool_offset)
		await get_tree().create_timer(0.5).timeout
		can_move = true
	if Input.is_action_just_pressed('build'):
		can_move = false
		building = true
		build_mode.emit()
		direction = Vector2.ZERO
		move_state_machine.travel('idle')
		$AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position", Vector2.DOWN)

		
func set_animation():
	if direction:
		move_state_machine.travel("Move")
		var direction_animation : Vector2 = Vector2(round(direction.x), round(direction.y))
		$AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position", direction_animation)
		$AnimationTree.set("parameters/MoveStateMachine/Move/blend_position", direction_animation)
		for state in state_names.values():
			$AnimationTree.set("parameters/ToolStateMachine/" + state + "/blend_position", direction_animation)
		$AnimationTree.set("parameters/FishingBlendSpace/blend_position", direction_animation)

	else:
		move_state_machine.travel("Idle")

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if not fishing:
		can_move = true
	else:
		$AnimationTree.set("parameters/FishBlend/blend_amount", 1)
	if current_tool == Global.Tools.HOE:
		$Audio/HoeSound.play()
	if current_tool == Global.Tools.WATER:
		$Audio/WaterSound.play()
	if current_tool == Global.Tools.FISH:
		$Audio/FishSound.play()

func axe_sword_swing():
	$Audio/AxeSwordSound.play()
	tool_interact.emit(current_tool, position + last_direction * tool_offset)

func _on_walk_timer_timeout() -> void:
	$Audio/WalkSound.play()

func stun():
	can_move = false
	$Timers/StunTimer.start()
	
func _on_stun_timer_timeout() -> void:
	can_move = true

func stop_fishing():
	fishing = false
	can_move = true
	$AnimationTree.set("parameters/FishBlend/blend_amount", 0)
	$FishGameContainer/FishGame.hide()

func get_fishing_input():
	direction = Input.get_vector("left", "right", "up", "down")
	if direction and not $Timers/FishDelayTimer.time_left:
		stop_fishing()
	if Input.is_action_just_pressed('action'):
		if $FishGameContainer/FishGame.get_fish():
			stop_fishing()
			
func get_resource(resource: Global.Resources, amount: int = 1):
	resources[resource] += amount
	resource_ui.update_resources()
