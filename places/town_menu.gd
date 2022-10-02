extends Control

signal back_pressed

func _ready() -> void:
	$VBoxContainer/continue.mouse_entered.connect(AudioManager._play_hover)
	$VBoxContainer/options.mouse_entered.connect(AudioManager._play_hover)
	$VBoxContainer/menu.mouse_entered.connect(AudioManager._play_hover)
	$VBoxContainer/exit.mouse_entered.connect(AudioManager._play_hover)

	$VBoxContainer/continue.pressed.connect(self._continue_pressed)
	$VBoxContainer/options.pressed.connect(self._options_pressed)
	$options.back_pressed.connect(self._back_from_options)
	$VBoxContainer/menu.pressed.connect(self._menu_pressed)
	$VBoxContainer/exit.pressed.connect(self._exit_pressed)

func _continue_pressed() -> void:
	back_pressed.emit()

func _options_pressed() -> void:
	await AudioManager._play_click()
	$VBoxContainer.visible = false
	$options.visible = true

func _back_from_options() -> void:
	$options.visible = false
	$VBoxContainer.visible = true

func _menu_pressed() -> void:
	await AudioManager._play_click()
	SceneManager.show_loading_screen(1, "Loading...")
	SceneManager.change_scene("res://menus/main_menu.tscn")

func _exit_pressed() -> void:
	await AudioManager._play_click()
	get_tree().quit()
