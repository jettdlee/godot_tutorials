extends CharacterBody2D

var direction : Vector2
var speed : int = 20
var health : int = 3:
	set(value):
		health = value
		if health <= 0:
			die()
var push_direction : Vector2
var push_distance := 130

@onready var player = get_tree().get_first_node_in_group('Player')

func _physics_process(_delta: float) -> void:
	direction = (player.position - position).normalized()
	velocity = direction * speed + push_direction
	move_and_slide()
	
func flash():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite.material, 'shader_parameter/progress', 1.0, 0.2)
	tween.tween_property($Sprite.material, 'shader_parameter/progress', 0.0, 0.4)

func push():
	var tween = get_tree().create_tween()
	var target = (player.position - position).normalized() * -1 * push_distance
	tween.tween_property(self, "push_direction", target, 0.1)
	tween.tween_property(self, "push_direction", Vector2.ZERO, 0.2)

func die():
	speed = 0
	$AnimationPlayer.current_animation = "explode"
	await  $AnimationPlayer.animation_finished
	if position.distance_to(player.position) < 12:
		player.stun()
	queue_free()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	die()
