extends Control

signal back_pressed
var _settin = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_settin = true
	$CenterContainer/VBoxContainer/music_vol_value.value = GlobalSettings.get_setting("audio/music_vol")
	$CenterContainer/VBoxContainer/sfx_vol2.value = GlobalSettings.get_setting("audio/sfx_vol")
	$CenterContainer/VBoxContainer/full_screen.button_pressed = GlobalSettings.get_setting("graphics/window_mode")

	$CenterContainer/VBoxContainer/music_vol_value.mouse_entered.connect(AudioManager._play_hover)
	$CenterContainer/VBoxContainer/sfx_vol2.mouse_entered.connect(AudioManager._play_hover)
	$CenterContainer/VBoxContainer/back.mouse_entered.connect(AudioManager._play_hover)
	$CenterContainer/VBoxContainer/full_screen.mouse_entered.connect(AudioManager._play_hover)

	$CenterContainer/VBoxContainer/full_screen.pressed.connect(self._full_screen_pressed)
	$CenterContainer/VBoxContainer/music_vol_value.value_changed.connect(self._on_music_vol_value_changed)
	$CenterContainer/VBoxContainer/sfx_vol2.value_changed.connect(self._on_sfx_vol_value_changed)
	$CenterContainer/VBoxContainer/back.pressed.connect(self._back_pressed)
	_settin = false

func _full_screen_pressed() -> void:
	if not _settin:
		await AudioManager._play_click()
	GlobalSettings.set_setting("graphics/window_mode", $CenterContainer/VBoxContainer/full_screen.button_pressed)

func _on_music_vol_value_changed(value: float) -> void:
	if not _settin:
		await AudioManager._play_click()
	GlobalSettings.set_setting("audio/music_vol", value)

func _on_sfx_vol_value_changed(value: float) -> void:
	if not _settin:
		await AudioManager._play_click()
	GlobalSettings.set_setting("audio/sfx_vol", value)

func _back_pressed() -> void:
	GlobalSettings.save()
	back_pressed.emit()
