extends Node3D

const equipment_type = 'Shield'
var defense: float

func flash():
	var tween = create_tween()
	tween.tween_method(_flash, 0.0, 1.0, 0.2)
	tween.tween_method(_flash, 1.0, 0.0, 0.2)
	
func _flash(value):
	get_child(0).get_child(0).material_overlay.set_shader_parameter('alpha', value)

func play_audio():
	$HitSound.play()
