extends Node

var weapons: Dictionary = {
	'dagger': 
		{
			'type': 'weapon',
			'damage': 1, 
			'thumbnail': preload("res://graphics/ui/thumbnails/dagger.png"), 
			'scene': preload("res://scenes/weapons/dagger.tscn"),
			'animation': '1H_Melee_Attack_Stab',
			'range': 1.2,
			'audio': preload("res://audio/dagger_sound.wav")
		},
	'sword': 
		{
			'type': 'weapon',
			'damage': 2, 
			'thumbnail': preload("res://graphics/ui/thumbnails/sword.png"), 
			'scene': preload("res://scenes/weapons/sword.tscn"),
			'animation': '1H_Melee_Attack_Slice_Horizontal',
			'range': 1.5,
			'audio': preload("res://audio/sword_sound.wav")
		},
	'axe': 
		{
			'type': 'weapon',
			'damage': 3, 
			'thumbnail': preload("res://graphics/ui/thumbnails/axe.png"), 
			'scene': preload("res://scenes/weapons/axe.tscn"),
			'animation': '2H_Melee_Attack_Spin',
			'range': 1.3,
			'audio': preload("res://audio/axe_sound.wav")
		},
		'staff': 
		{
			'type': 'weapon',
			'damage': 1, 
			'thumbnail': preload("res://graphics/ui/thumbnails/staff.png"), 
			'scene': preload("res://scenes/weapons/staff.tscn"),
			'animation': '2H_Melee_Attack_Slice',
			'range': 2.1,
			'audio': preload("res://audio/staff_sound.wav")
		},
}
var shields: Dictionary = {
	'square': {
		'type': 'shield',
		'defense': 0.8,
		'thumbnail': preload("res://graphics/ui/thumbnails/square.png"),
		'scene': preload("res://scenes/shields/square_shield.tscn")
	},
	'round': {
		'type': 'shield',
		'defense': 0.9,
		'thumbnail': preload("res://graphics/ui/thumbnails/round.png"),
		'scene': preload("res://scenes/shields/round_shield.tscn")
	},
	'spike': {
		'type': 'shield',
		'defense': 0.6,
		'thumbnail': preload("res://graphics/ui/thumbnails/spike.png"),
		'scene': preload("res://scenes/shields/spike_shield.tscn")
	},
}
var style: Dictionary = {
	'sunglasses': {
		'type': 'style',
		'scene': preload("res://scenes/style/sunglasses.tscn"),
		'thumbnail': preload("res://graphics/ui/thumbnails/sun_glasses.png")
	},
	'starglasses': {
		'type': 'style',
		'scene': preload("res://scenes/style/starglasses.tscn"),
		'thumbnail': preload("res://graphics/ui/thumbnails/star_glasses.png")
	},
	'duckhat': {
		'type': 'style',
		'scene': preload("res://scenes/style/duck_hat.tscn"),
		'thumbnail': preload("res://graphics/ui/thumbnails/duck.png")
	},
	'tophat': {
		'type': 'style',
		'scene': preload("res://scenes/style/tophat.tscn"),
		'thumbnail': preload("res://graphics/ui/thumbnails/top_hat.png")
	},
}
