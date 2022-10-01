extends Control

signal back_pressed

const MIN_STAT = 1
const MAX_STAT = 100

var stats : character_stats

func _ready() -> void:
	stats = character_stats.new()

	%name.text_changed.connect(self._name_changed)
	for node in $HBoxContainer/stats/name/stats/GridContainer.get_children():
		if node is Button:
			node.pressed.connect(self._stats_button_presed.bind(str(node.name).split("_")[0], -1 if str(node.name).contains("less") else 1))

	$HBoxContainer/stats/name/back.pressed.connect(self._back_presed)
	$HBoxContainer/style2/VBoxContainer/start.pressed.connect(self.start_pressed)
	_update_stats_ui()

func _back_presed() -> void:
	back_pressed.emit()

func start_pressed() -> void:
	if stats.name == "":
		return
	PlayerProfile.set_stats(stats)
	SceneManager.show_loading_screen(1, "Loading...")
	SceneManager.change_scene("res://places/entry_town.tscn")

func make_visable(p_stats : character_stats) -> void:
	stats = p_stats
	_update_stats_ui()
	visible = true

func _name_changed(new_name : String) -> void:
	stats.name = new_name

func _stats_button_presed(node_name : String, inc_value : int) -> void:
	if (stats.get_allocations_remaining() <= 0 && inc_value > 0):
		return

	match node_name:
		"health":
			stats.health = clamp(stats.health + inc_value, MIN_STAT, MAX_STAT)
		"stamina":
			stats.stamina = clamp(stats.stamina + inc_value, MIN_STAT, MAX_STAT)
		"mana":
			stats.mana = clamp(stats.mana + inc_value, MIN_STAT, MAX_STAT)
		"agility":
			stats.agility = clamp(stats.agility + inc_value, MIN_STAT, MAX_STAT)
		"constitution":
			stats.constitution = clamp(stats.constitution + inc_value, MIN_STAT, MAX_STAT)
		"strength":
			stats.strength = clamp(stats.strength + inc_value, MIN_STAT, MAX_STAT)
		"wisdom":
			stats.wisdom = clamp(stats.wisdom + inc_value, MIN_STAT, MAX_STAT)
		"luck":
			stats.luck = clamp(stats.luck + inc_value, MIN_STAT, MAX_STAT)

	_update_stats_ui()

func _update_stats_ui() -> void:
	%name.text = stats.name
	%to_allocate.text = str(stats.get_allocations_remaining())
	%health_value.text = str(stats.health)
	%stamina_value.text = str(stats.stamina)
	%mana_value.text = str(stats.mana)
	%agility_value.text = str(stats.agility)
	%constitution_value.text = str(stats.constitution)
	%strength_value.text = str(stats.strength)
	%wisdom_value.text = str(stats.wisdom)
	%luck_value.text = str(stats.luck)
