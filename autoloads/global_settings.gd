extends Node

enum window_mode {
	windowed = 0,
	fullscreen = 1
}

var _dirty = false
var settings := {
	"graphics/window_mode": 0,

	"audio/music_vol": -5,
	"audio/sfx_vol": -5
}

func get_setting(seting):
	if settings.has(seting):
		return settings[seting]
	return null

func set_setting(seting, value):
	settings[seting] = value
	_dirty = true
	if seting == "audio/music_vol" || seting == "audio/sfx_vol":
		_update_audio_settings()
	if (seting == "graphics/window_mode"):
		_update_window_settings()

func _ready() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		merge_dir(settings, config.get_value("settings", "user", {}))
	_update_audio_settings()
	_update_window_settings()

func merge_dir(target, patch):
	for key in patch:
		target[key] = patch[key]

func save():
	if !_dirty:
		return
	var config = ConfigFile.new()
	config.set_value("settings", "user", settings)
	config.save("user://settings.cfg")


func _update_audio_settings():
	AudioServer.set_bus_volume_db(abs(AudioServer.get_bus_index("music")), settings["audio/music_vol"])
	AudioServer.set_bus_volume_db(abs(AudioServer.get_bus_index("sfx")), settings["audio/sfx_vol"])

func _update_window_settings():
	var value = settings["graphics/window_mode"]
	var windows = DisplayServer.get_window_list()

	if !value:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		return

	if value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		return
