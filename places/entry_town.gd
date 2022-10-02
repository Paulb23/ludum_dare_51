extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$town_view.visible = true
	$world_map.visible = false

	$town_view/weapon_shop.pressed.connect(self._weapon_shop_pressed)
	$town_view/mana_shop.pressed.connect(self._mana_shop_pressed)
	$town_view/armour_shop.pressed.connect(self._armour_shop_pressed)
	$town_view/to_stats.pressed.connect(self._stats_pressed)

	$character_creator.hide_start()
	$character_creator.back_pressed.connect(self._back_from_stats)

	$town_view/to_map.pressed.connect(self._map_pressed)
	$world_map/town.pressed.connect(self._town_pressed)

	$world_map/level_1.pressed.connect(self._load_level.bind("level_1"))

	SceneManager.hide_loading_screen()

func _weapon_shop_pressed() ->void:
	$shop.load_shop("weapons")
	$shop.visible = true

func _mana_shop_pressed() ->void:
	$shop.load_shop("magic")
	$shop.visible = true

func _armour_shop_pressed() -> void:
	$shop.load_shop("armour")
	$shop.visible = true

func _map_pressed() -> void:
	$town_view.visible = false
	$world_map.visible = true

func _town_pressed() -> void:
	$town_view.visible = true
	$world_map.visible = false

func _stats_pressed() -> void:
	$character_creator.make_visable(PlayerProfile.get_stats())

func _back_from_stats() -> void:
	PlayerProfile.set_stats($character_creator.stats)
	$character_creator.visible = false

func _load_level(level : String) -> void:
	SceneManager.show_loading_screen(1, "Loading...")
	SceneManager.set_current_level("level_1")
	SceneManager.change_scene("res://places/arena.tscn")
