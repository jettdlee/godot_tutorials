extends CharacterBody2D

@onready var move_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var tool_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/ToolStateMachine/playback")
const state_names = {
	Global.Tools.HOE: 'hoe',
	Global.Tools.AXE: 'axe',
	Global.Tools.WATER: 'water',
	Global.Tools.SWORD: 'sword',
	Global.Tools.FISH: 'fish'
}

var direction: Vector2
@export var speed := 200
var can_move : bool = true
var current_tool: Global.Tools = Global.Tools.HOE

func _physics_process(_delta: float) -> void:
	if can_move:
		get_input()
	set_animation()
	velocity = direction * speed * int(can_move)
	move_and_slide()

func get_input():
	direction = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_just_pressed("action"):
		tool_state_machine.travel(state_names[current_tool])
		$AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		can_move = false
	
	if Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward"):
		var toggle_direction = int(Input.get_axis("tool_backward", "tool_forward"))
		current_tool = posmod(current_tool + toggle_direction, Global.Tools.size()) as Global.Tools
		$PlayerUI.reveal(current_tool)

func set_animation():
	if direction:
		move_state_machine.travel("Move")
		var direction_animation : Vector2 = Vector2(round(direction.x), round(direction.y))
		$AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position", direction_animation)
		$AnimationTree.set("parameters/MoveStateMachine/Move/blend_position", direction_animation)
		for state in state_names.values():
			$AnimationTree.set("parameters/ToolStateMachine/" + state + "/blend_position", direction_animation)
	else:
		move_state_machine.travel("Idle")

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	can_move = true
