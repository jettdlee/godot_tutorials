extends AnimatableBody3D

var direction = 1
@export var speed: float = 4.0

func _physics_process(delta: float) -> void:
	position.x += speed * direction * delta


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body != self:
		direction *= -1
