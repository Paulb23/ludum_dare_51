extends Node

var stats : character_stats

func set_stats(p_stats : character_stats) -> void:
	stats = p_stats
	stats.is_player = true
	ResourceSaver.save(stats, "user://stats.save")

func get_stats() -> character_stats:
	return stats.duplicate()

func has_stats() -> bool:
	return Filesystem.has_resource("user://stats.save")

func load_stats() -> void:
	stats = await Filesystem.load_resource("user://stats.save")
