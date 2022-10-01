extends Control

var players_turn := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for action in %actions.get_children():
		action.pressed.connect(self._do_action.bind(action.name))

	%player.stats = PlayerProfile.get_stats()

	%player_stats/health_value.max_value = %player.stats.health
	%player_stats/stamina_value.max_value = %player.stats.stamina
	%player_stats/mana_value.max_value = %player.stats.mana

	%ai_stats/health_value.max_value = %ai.stats.health
	%ai_stats/stamina_value.max_value = %ai.stats.stamina
	%ai_stats/mana_value.max_value = %ai.stats.mana

	_update_ui()
	%player.ready_up()
	%ai.ready_up()
	SceneManager.hide_loading_screen()

func _update_ui() -> void:
	%player_stats/name.text = str(%player.stats.name)
	%player_stats/health_value.value = %player.stats.health
	%player_stats/stamina_value.value = %player.stats.stamina
	%player_stats/mana_value.value = %player.stats.mana

	%ai_stats/name.text = str(%ai.stats.name)
	%ai_stats/health_value.value = %ai.stats.health
	%ai_stats/stamina_value.value = %ai.stats.stamina
	%ai_stats/mana_value.value = %ai.stats.mana

	if !players_turn:
		for action in %actions.get_children():
			action.disabled = true
	else:
		for action in %actions.get_children():
				action.disabled = false

		if !%player.enough_stamina_for_attack():
			%actions/attack.disabled = true

		if !%player.enough_stamina_for_quick_attack():
			%actions/quick_attack.disabled = true

		if !%player.enough_stamina_for_move():
			%actions/move_left.disabled = true
			%actions/move_right.disabled = true

		if %player.at_max_health():
			%actions/heal.disabled = true

		if %player.at_max_stamina():
			%actions/rest.disabled = true

		if %player.at_max_mana():
			%actions/power_up.disabled = true


func _end_turn() -> void:
	players_turn = !players_turn
	if !players_turn:
		%ai.do_turn(%player)
		_end_turn()
		return

	if %ai.stats.health <= 0:
		# do somthing
		SceneManager.show_loading_screen(1, "Loading...")
		SceneManager.change_scene("res://places/entry_town.tscn")
		return

	if %player.stats.health <= 0:
		SceneManager.show_loading_screen(1, "Loading...")
		SceneManager.change_scene("res://menus/main_menu.tscn")
		return

	_update_ui()

func _do_action(action : String) -> void:
	match action:
		"attack":
			%player.do_attack(%ai)
		"quick_attack":
			%player.do_quick_attack(%ai)
		"swap":
			%player.do_swap(%ai)
		"heal":
			%player.do_heal(%ai)
		"powerup":
			%player.do_powerup(%ai)
		"move_left":
			%player.do_move_left(%ai)
		"move_right":
			%player.do_move_right(%ai)
		"jump":
			%player.do_jump(%ai)
		"rest":
			%player.do_rest(%ai)
		"run":
			%player.do_run(%ai)
	_end_turn()
