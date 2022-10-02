extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$town_view.visible = true
	$world_map.visible = false

	$town_view/weapon_shop.pressed.connect(self._weapon_shop_pressed)

	$town_view/to_map.pressed.connect(self._map_pressed)
	$world_map/town.pressed.connect(self._town_pressed)

	$world_map/level_1.pressed.connect(self._load_level.bind("level_1"))

	SceneManager.hide_loading_screen()

func _weapon_shop_pressed() ->void:
	$shop.load_shop("weapons")
	$shop.visible = true

func _map_pressed() -> void:
	$town_view.visible = false
	$world_map.visible = true

func _town_pressed() -> void:
	$town_view.visible = true
	$world_map.visible = false

func _load_level(level : String) -> void:
	SceneManager.show_loading_screen(1, "Loading...")
	SceneManager.set_current_level("level_1")
	SceneManager.change_scene("res://places/arena.tscn")
