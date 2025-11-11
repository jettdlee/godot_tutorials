extends GPUParticles3D

@onready var body : CharacterBody3D = $".."

func _process(delta: float) -> void:
	emitting = _can_emit()
	
func _can_emit() -> bool:
	if body.velocity.length() < 0.1:
		return false
	if not body.is_on_floor():
		return false
		
	return true
