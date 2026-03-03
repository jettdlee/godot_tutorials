extends StaticBody2D

const apple_texture = preload("res://graphics/plants/apple.png")
var health : int = 3:
	set(value):
		health = value
		if health <= 0 and alive:
			$Sprite.hide()
			$Stump.show()
			var shape = RectangleShape2D.new()
			shape.size = Vector2(12, 6)
			$CollisionShape2D.shape = shape
			$CollisionShape2D.position.y = 8
			player.get_resource(Global.Resources.WOOD, randi_range(2,4))
			alive = false

@onready var player = get_tree().get_first_node_in_group('Player')
var alive: bool = true

func _ready() -> void:
	$Sprite.frame = [0, 1].pick_random()
	create_apples(randi_range(0,3))

func cut():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite.material, 'shader_parameter/progress', 1.0, 0.2)
	tween.tween_property($Sprite.material, 'shader_parameter/progress', 0.0, 0.4)
	

func create_apples(num : int):
	if health > 0:
		var apple_markers = $ApplePositions.get_children().duplicate(true)
		for i in num:
			var pos_marker = apple_markers.pop_at(randi_range(0, apple_markers.size() - 1))
			var sprite = Sprite2D.new()
			sprite.texture = apple_texture
			$Apples.add_child(sprite)
			sprite.position = pos_marker.position

func get_apple():
	if $Apples.get_children():
		$Apples.get_children().pick_random().queue_free()
		player.get_resource(Global.Resources.APPLE)
		

func reset():
	for apple in $Apples.get_children():
		apple.queue_free()
	create_apples(randi_range(0, 2))
