extends Control


func show() -> void:
	visible = true

func hide() -> void:
	visible = false

func set_status_text(status_text : String) -> void:
	$center_container/status.text = "[wave amp=50 feq=5]" + tr(status_text)+ "[/wave]"

func set_percent_complete(percent : int) -> void:
	$progress.value = percent
