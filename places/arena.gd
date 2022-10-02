extends Control

var turn_time = 10

var game_over := false
var player_won := false
var players_turn := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$game_over/VBoxContainer/leave.pressed.connect(self.leave)
	$game_over/VBoxContainer/leave.mouse_entered.connect(AudioManager._play_hover)

	for action in %actions.get_children():
		action.pressed.connect(self._do_action.bind(action.name))
		action.mouse_entered.connect(AudioManager._play_hover)

	%player.stats = PlayerProfile.get_stats()

	%player_stats/health_value.max_value = %player.stats.health
	%player_stats/stamina_value.max_value = %player.stats.stamina
	%player_stats/mana_value.max_value = %player.stats.mana

	%ai_stats/health_value.max_value = %ai.stats.health
	%ai_stats/stamina_value.max_value = %ai.stats.stamina
	%ai_stats/mana_value.max_value = %ai.stats.mana

	%player.ready_up()
	%ai.ready_up()
	_update_ui()
	AudioManager._play_battle_music()
	SceneManager.hide_loading_screen()

func _update_ui() -> void:
	%player_stats/name.text = str(%player.stats.name)
	%player_stats/health_value.value = %player.stats.health
	%player_stats/health_value/value.text = str(%player.stats.health, "/", %player.max_health)
	%player_stats/stamina_value.value = %player.stats.stamina
	%player_stats/stamina_value/value.text = str(%player.stats.stamina, "/", %player.max_stamina)
	%player_stats/mana_value.value = %player.stats.mana
	%player_stats/mana_value/value.text = str(%player.stats.mana, "/", %player.max_mana)

	%ai_stats/name.text = str(%ai.stats.name)
	%ai_stats/health_value.value = %ai.stats.health
	%ai_stats/health_value/value.text = str(%ai.stats.health, "/", %ai.max_health)
	%ai_stats/stamina_value.value = %ai.stats.stamina
	%ai_stats/stamina_value/value.text = str(%ai.stats.stamina, "/", %ai.max_stamina)
	%ai_stats/mana_value.value = %ai.stats.mana
	%ai_stats/mana_value/value.text = str(%ai.stats.mana, "/", %ai.max_mana)

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

		if !%player.enough_stamina_for_jump():
			%actions/jump.disabled = true

		if %player.at_max_health():
			%actions/heal.disabled = true

		if %player.at_max_stamina():
			%actions/rest.disabled = true

		if %player.at_max_mana():
			%actions/power_up.disabled = true


func _end_turn() -> void:
	if game_over:
		return

	turn_time = 10
	players_turn = !players_turn
	if !players_turn:
		%ai.do_turn(%player)
		_end_turn()
		return

	if %ai.stats.health <= 0:
		game_over = true
		player_won = true
		PlayerProfile.stats.gold += %ai.stats.gold
		PlayerProfile.stats.xp += %ai.stats.xp
		if !PlayerProfile.stats.levels_beaten.has(SceneManager.get_current_level()):
			PlayerProfile.stats.levels_beaten.push_back(SceneManager.get_current_level())

		var level_up : bool = PlayerProfile.stats.xp > 50
		if (PlayerProfile.stats.xp > 50):
			PlayerProfile.stats.max_allocated_stats += 5
			PlayerProfile.stats.xp = 0

		PlayerProfile.set_stats(PlayerProfile.get_stats())
		await %ai.death()
		$game_over/VBoxContainer/Label.text = "You Won!"
		$game_over/VBoxContainer/gold.text = str("You gained ", %ai.stats.gold, " gold")
		$game_over/VBoxContainer/xp.text = str("You gained ", %ai.stats.xp, " xp", " and leveled up!" if level_up else "")
		$game_over/VBoxContainer/leave.text = "Back to Town"
		$game_over.visible = true
		return

	if %player.stats.health <= 0:
		game_over = true
		player_won = false

		await %player.death()
		$game_over/VBoxContainer/Label.text = "You Died."
		$game_over/VBoxContainer/gold.text = ""
		$game_over/VBoxContainer/xp.text = ""
		$game_over/VBoxContainer/leave.text = "Main Menu"
		$game_over.visible = true
		return

	_update_ui()

func leave() -> void:
	AudioManager._play_click()
	if player_won:
		SceneManager.show_loading_screen(1, "Loading...")
		if SceneManager.get_current_level() == "level_15":
			SceneManager.change_scene("res://menus/end_cut_scene.tscn")
			return
		SceneManager.change_scene("res://places/entry_town.tscn")
		return

	SceneManager.show_loading_screen(1, "Loading...")
	SceneManager.change_scene("res://menus/main_menu.tscn")

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
			game_over = true
			player_won = true

			$game_over/VBoxContainer/Label.text = "You ran away."
			$game_over/VBoxContainer/gold.text = ""
			$game_over/VBoxContainer/xp.text = ""
			$game_over/VBoxContainer/leave.text = "Back to Town"
			$game_over.visible = true
	_end_turn()


func _on_timer_timeout() -> void:
	if game_over:
		return
	turn_time -= 1
	if turn_time == 0:
		_end_turn()
	$Label.text = str(turn_time)
