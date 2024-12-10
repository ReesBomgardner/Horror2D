extends TileMapLayer

@onready var furnitures: TileMapLayer = $"../Furnitures"
@onready var furnitures2: TileMapLayer = $"../Furnitures2"

func _ready():	
	GameManager.set_gui(false)
	pass

func _use_tile_data_runtime_update(coords):
	if coords in furnitures.get_used_cells():
		return true
	return false
	pass

func _tile_data_runtime_update(coords, tile_data):
	if coords in furnitures.get_used_cells():
		tile_data.set_navigation_polygon(0, null)
	pass
