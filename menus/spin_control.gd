extends HBoxContainer

signal changed(value)

var idx = 0
@export var values := []

func _ready() -> void:
	$hair_color_value.text = values[idx]
	$prev.pressed.connect(self._prev_presseed)
	$next.pressed.connect(self._next_presseed)

	$prev.mouse_entered.connect(AudioManager._play_hover)
	$next.mouse_entered.connect(AudioManager._play_hover)

func _prev_presseed() -> void:
	AudioManager._play_click()
	idx -= 1
	if idx < 0:
		idx = values.size() - 1
	$hair_color_value.text = values[idx]
	changed.emit(values[idx])

func _next_presseed() -> void:
	AudioManager._play_click()
	idx += 1
	if idx > values.size() - 1:
		idx = 0
	$hair_color_value.text = values[idx]
	changed.emit(values[idx])
