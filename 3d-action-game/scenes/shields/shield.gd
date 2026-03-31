extends Node3D

var defense: float
const equipment_type = 'Shield'

func flash():
	var tween = create_tween()
	tween.tween_method(_flash, 0.0, 1.0, 0.2)
	tween.tween_method(_flash, 1.0, 0.0, 0.4)
	
func _flash(value):
	get_child(0).get_child(0).material_overlay.set_shader_parameter('alpha', value)


func play_audio():
	$HitSound.play()
