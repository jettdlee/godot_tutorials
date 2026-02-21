extends Node

@export var node_scene : PackedScene
var cached_nodes : Array[Node]

func _create_new() -> Node:
	var node = node_scene.instantiate()
	cached_nodes.append(node)
	get_tree().get_root().add_child.call_deferred(node)
	return node

func spawn() -> Node:
	for node in cached_nodes:
		if node.visible == false:
			node.visible = true
			return node
	
	return _create_new()
