extends Camera3D

var intensity : float = 0

func _ready ():
	get_parent().OnTakeDamage.connect(_damage_shake)

func _damage_shake(health:int):
	intensity = 0.1
	
func _process(delta: float) -> void:
	if intensity > 0:
		intensity = lerp(intensity, 0.0, delta * 10)
		var offset : Vector2 = _get_random_offset()
		h_offset = offset.x
		v_offset = offset.y

func _get_random_offset() -> Vector2:
	var x = randf_range(-intensity, intensity)
	var y = randf_range(-intensity, intensity)
	return Vector2(x, y)
