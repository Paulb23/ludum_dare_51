extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$buttons/container/play.pressed.connect(self._play_pressed)
	$buttons/container/continue.pressed.connect(self._continue_pressed)
	$buttons/container/exit.pressed.connect(self._exit_pressed)
	$character_creator.back_pressed.connect(self._back_pressed)

	$buttons/container/continue.disabled = !PlayerProfile.has_stats()

	AudioManager._play_menu_music()
	if SceneManager.is_loading():
		SceneManager.hide_loading_screen()

func _play_pressed() -> void:
	_hide_all()
	$character_creator.make_visable(character_stats.new())

func _continue_pressed() -> void:
	PlayerProfile.load_stats()
	SceneManager.show_loading_screen(1, "Loading...")
	SceneManager.change_scene("res://places/entry_town.tscn")

func _back_pressed() -> void:
	_hide_all()
	$buttons.visible = true

func _exit_pressed() -> void:
	get_tree().quit()

func _hide_all():
	$buttons.visible = false
	$character_creator.visible = false
