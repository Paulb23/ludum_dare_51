extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene = preload("res://music/music.tscn")
	add_child(scene.instantiate())


func _play_town_music():
	$music/battle_theme.stop()
	$music/menu_theme.stop()
	$music/town_theme.play()

func _play_battle_music():
	$music/town_theme.stop()
	$music/menu_theme.stop()
	$music/battle_theme.play()

func _play_menu_music():
	$music/town_theme.stop()
	$music/battle_theme.stop()
	$music/menu_theme.play()

func _play_hover():
	$music/button_hover.play()

func _play_click():
	$music/button_click.play()
	await $music/button_click.finished
