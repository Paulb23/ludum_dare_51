extends Control

var text_displayed = false

func _ready() -> void:
	AudioManager._play_menu_music()
	SceneManager.hide_loading_screen()

func _on_timer_timeout() -> void:
	$RichTextLabel.visible_characters += 1
	if $RichTextLabel.visible_ratio >= 1:
		text_displayed = true
		$Timer.stop()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton || event is InputEventKey:
		if text_displayed:
			SceneManager.show_loading_screen(1, "Loading...")
			AudioManager._play_click()
			SceneManager.change_scene("res://places/entry_town.tscn")
