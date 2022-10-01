extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.set_scene_root(self)
	SceneManager.show_loading_screen(1, "Loading...")
	SceneManager.change_scene("res://menus/main_menu.tscn")
	SceneManager.hide_loading_screen()
