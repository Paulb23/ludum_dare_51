extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$town_view.visible = true
	$world_map.visible = false

	$town_view/weapon_shop.mouse_entered.connect(AudioManager._play_hover)
	$town_view/mana_shop.mouse_entered.connect(AudioManager._play_hover)
	$town_view/armour_shop.mouse_entered.connect(AudioManager._play_hover)
	$town_view/to_stats.mouse_entered.connect(AudioManager._play_hover)
	$town_view/to_map.mouse_entered.connect(AudioManager._play_hover)
	$world_map/town.mouse_entered.connect(AudioManager._play_hover)
	$town_view/to_menu.mouse_entered.connect(AudioManager._play_hover)

	$town_view/weapon_shop.pressed.connect(self._weapon_shop_pressed)
	$town_view/mana_shop.pressed.connect(self._mana_shop_pressed)
	$town_view/armour_shop.pressed.connect(self._armour_shop_pressed)
	$town_view/to_stats.pressed.connect(self._stats_pressed)
	$town_view/to_menu.pressed.connect(self._to_menu_pressed)

	$character_creator.hide_start()
	$character_creator.back_pressed.connect(self._back_from_stats)

	$town_menu.back_pressed.connect(self._back_from_menu)

	$town_view/to_map.pressed.connect(self._map_pressed)
	$world_map/town.pressed.connect(self._town_pressed)

	var should_disbaled = false
	for node in $world_map.get_children():
		if node is Button:
			if node.name == "town":
				continue

			node.mouse_entered.connect(AudioManager._play_hover)
			node.pressed.connect(self._load_level.bind(node.name))
			if should_disbaled:
				node.disabled = true

			if !PlayerProfile.stats.levels_beaten.has(str(node.name)):
				should_disbaled = true

	AudioManager._play_town_music()
	SceneManager.hide_loading_screen()

func _weapon_shop_pressed() ->void:
	AudioManager._play_click()
	$shop.load_shop("weapons")
	$shop.visible = true

func _mana_shop_pressed() ->void:
	AudioManager._play_click()
	$shop.load_shop("magic")
	$shop.visible = true

func _armour_shop_pressed() -> void:
	AudioManager._play_click()
	$shop.load_shop("armour")
	$shop.visible = true

func _to_menu_pressed() -> void:
	AudioManager._play_click()
	$town_menu.visible = true

func _map_pressed() -> void:
	AudioManager._play_click()
	$town_view.visible = false
	$world_map.visible = true

func _town_pressed() -> void:
	AudioManager._play_click()
	$town_view.visible = true
	$world_map.visible = false

func _stats_pressed() -> void:
	AudioManager._play_click()
	$character_creator.make_visable(PlayerProfile.get_stats())

func _back_from_stats() -> void:
	AudioManager._play_click()
	PlayerProfile.set_stats($character_creator.stats)
	$character_creator.visible = false

func _back_from_menu() -> void:
	AudioManager._play_click()
	$town_menu.visible = false

func _load_level(level : String) -> void:
	AudioManager._play_click()
	SceneManager.show_loading_screen(1, "Loading...")
	SceneManager.set_current_level(level)
	SceneManager.change_scene("res://places/arena.tscn")
