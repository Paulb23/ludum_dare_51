extends Node

var _res_full_path := ""

var _res_location := "res://"

func has_resource(path : String) -> bool:
	return ResourceLoader.exists(path)

func load_resource(path : String) -> Resource:
	return (await _load([path]))[0]

func load_resources(paths : Array[String]) -> Resource:
	return await _load(paths)

# private

signal _items_loaded
var _items_to_load : Dictionary

func _load(paths : Array[String]) -> Array[Resource]:
	# add items to queue
	var _need_to_wait := false
	for path in paths:
		if _items_to_load.has(path):
			_handle_loading_error(path)

		if ResourceLoader.has_cached(path):
			_items_to_load[path] = ResourceLoader.load(path)
			continue

		_need_to_wait = true
		var error = ResourceLoader.load_threaded_request(path)
		if error != OK:
			_handle_loading_error(path)
		_items_to_load[path] = null

	# wait for all of the items to load.
	while _need_to_wait:
		await _items_loaded

		var all_loaded := true
		for path in paths:
			if _items_to_load[path] == null:
				all_loaded = false
				break

		if all_loaded:
			break

	# Keep order
	var resources := []
	for path in paths:
		resources.push_back(_items_to_load[path])
		_items_to_load.erase(path)
	return resources as Array[Resource]

func _process(delta : float) -> void:
	var new_items_loaded = false

	for path in _items_to_load:
		if _items_to_load[path] != null:
			continue

		var status = ResourceLoader.load_threaded_get_status(path)
		if status == ResourceLoader.THREAD_LOAD_FAILED || status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			_handle_loading_error(path)

		if status == ResourceLoader.THREAD_LOAD_LOADED:
			_items_to_load[path] = ResourceLoader.load_threaded_get(path)
			new_items_loaded = true

	if new_items_loaded:
		_items_loaded.emit()

func _handle_loading_error(path : String) -> void:
	OS.alert("Failed to load resource: '" + path + "'", "Error!")
	get_tree().quit()

func _ready() -> void:
	_res_location = OS.get_executable_path().get_base_dir()
	if OS.has_feature("editor"):
		_res_location = ProjectSettings.globalize_path("res://")
	set_process(true)
