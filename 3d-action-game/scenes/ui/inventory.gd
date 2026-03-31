extends Control

@onready var player_preview = get_tree().get_first_node_in_group("PlayerPreview")
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var item_scene = preload("res://scenes/ui/item.tscn")
@export var pan_speed:float = 3

@onready var weapon_grid = $HBoxContainer/ItemPanelContainer/MarginContainer2/TabContainer/Weapons
@onready var shield_grid = $HBoxContainer/ItemPanelContainer/MarginContainer2/TabContainer/Shields
@onready var style_grid = $HBoxContainer/ItemPanelContainer/MarginContainer2/TabContainer/Style
@onready var tab_container = $HBoxContainer/ItemPanelContainer/MarginContainer2/TabContainer
const border_colors = [Color.LIME_GREEN, Color.FIREBRICK, Color.GOLDENROD]

func reveal():
	for child in tab_container.get_children():
		for node in child.get_children():
			node.queue_free()
	show()
	create_inventory_items(weapon_grid, player.weapons, player.weapon_index)
	create_inventory_items(shield_grid, player.shields, player.shield_index)
	create_inventory_items(style_grid, player.styles, player.style_index)
	focus()


func focus():
	await get_tree().create_timer(0.01).timeout
	if tab_container.get_child(tab_container.current_tab).get_child_count():
		tab_container.get_child(tab_container.current_tab).get_child(0).grab_focus()


func _process(delta: float) -> void:
	var pan_dir = Input.get_axis("pan_left", "pan_right")
	player_preview.rotate_y(pan_dir * delta * pan_speed)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		Global.pause(false)
	var menu_dir = int(Input.get_axis("switch_shield", "switch_weapon"))
	if menu_dir:
		tab_container.current_tab = posmod(tab_container.current_tab + menu_dir, tab_container.get_child_count())
		focus()
		$HBoxContainer/ItemPanelContainer/Control/Label.text = tab_container.get_child(tab_container.current_tab).name
		var color = border_colors[tab_container.current_tab]
		$HBoxContainer/ItemPanelContainer/MarginContainer/Panel.get_theme_stylebox("panel").border_color = color
		$HBoxContainer/ItemPanelContainer/Control/Label.add_theme_color_override("font_color",color)
	if Input.is_action_just_pressed("run"):
		if tab_container.current_tab == 2:
			player_preview.unequip()
			player.unequip()

func create_inventory_items(container: GridContainer, equipment_list: Array, index: int):
	for i in equipment_list.size():
		var equipment_item = equipment_list[i]
		var item_instance = item_scene.instantiate()
		item_instance.setup(equipment_item)
		container.add_child(item_instance)
		item_instance.highlight(i == index)
		if i == index:
			player_preview.add_equipment(equipment_item)
