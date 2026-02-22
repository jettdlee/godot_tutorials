extends Node

enum Seeds {CORN, TOMATO, PUMPKIN}
enum Tools {HOE, AXE, SWORD, WATER, FISH}
enum Objects {WALLS, DOOR, CARPET, BED, PLANT, SHELF, TABLE}
enum Resources {APPLE, WOOD, FISH, CORN, TOMATO, PUMPKIN}
const resource_seed_connection = {
	Global.Seeds.CORN: Global.Resources.CORN,
	Global.Seeds.TOMATO: Global.Resources.TOMATO,
	Global.Seeds.PUMPKIN: Global.Resources.PUMPKIN,
}
const TILE_SIZE = 16
