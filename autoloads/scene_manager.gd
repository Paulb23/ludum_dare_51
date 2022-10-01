extends Node


var _scene_root : Node

var _active_scene_root : Node
var _next_scene_path : String

var _current_level_path : String

func set_current_level(path : String) -> void:
	_current_level_path = path

func get_current_level() -> String:
	return _current_level_path

func change_scene(path : String) -> void:
	# free the current scene
	if _active_scene_root.get_child_count() > 0:
		_active_scene_root.get_child(0).queue_free()

	# start loading on a new thread
	_next_scene_path = path
	var error = ResourceLoader.load_threaded_request(path)
	if error != OK:
		_handle_loading_error()
	set_process(true)

func _process(_delta : float) -> void:
	var progress= []
	var status = ResourceLoader.load_threaded_get_status(_next_scene_path, progress)

	if _loading:
		set_loading_stage_percent_complete(progress.size())

	if status == ResourceLoader.THREAD_LOAD_FAILED || status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
		_handle_loading_error()

	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(_next_scene_path).instantiate()
		_active_scene_root.add_child(new_scene)
		set_process(false)

func _handle_loading_error() -> void:
	OS.alert("Failed to load scene: '" + _next_scene_path + "'", "Error!")
	quit()

func quit() -> void:
	get_tree().quit()

###############################################################################
#                                 Loading screen                              #
###############################################################################

var _loading := false

var _percent_per_stage := 100
var _current_stage := 0
var _stage_count := 1

var _current_percent := 0
var _loading_screen : Node

func set_loading_stage_percent_complete(percent : int) -> void:
	percent = (percent * _percent_per_stage) / 100
	_current_percent = (_percent_per_stage * _current_stage) + percent
	_loading_screen.set_percent_complete(_current_percent)

func set_loading_screen_status_text(status_text : String) -> void:
	_loading_screen.set_status_text(status_text)

func increment_loading_stage(status_text : String) -> void:
	if _current_stage < _stage_count:
		_current_stage += 1
	_loading_screen.set_status_text(status_text)
	set_loading_stage_percent_complete(0)

func show_loading_screen(stages : int, status_text : String) -> void:
	assert(!_loading)
	_loading = true

	_stage_count = stages
	_percent_per_stage = (100 / _stage_count)

	_current_percent = 0

	set_loading_stage_percent_complete(0)
	_loading_screen.set_status_text(status_text)
	_loading_screen.show()

func hide_loading_screen() -> void:
	assert(_loading)
	_loading_screen.hide()
	_loading = false

func is_loading() -> bool:
	return _loading

###############################################################################
#                                     Engine                                  #
###############################################################################

# "constructor"
func set_scene_root(node : Node) -> void:
		_scene_root = node
		_active_scene_root = _scene_root.get_child(0)
		_loading_screen = _scene_root.get_child(1)

func _ready() -> void:
	set_process(false)
