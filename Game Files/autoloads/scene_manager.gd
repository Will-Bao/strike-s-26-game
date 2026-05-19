extends Node

var scenes: Dictionary[String, PackedScene] = {
	"character_select": preload("res://scenes/character_select/character_select.tscn"),
	"level": preload("res://scenes/world/level.tscn"),
	"win": preload("res://scenes/win_screen/win_screen.tscn")
}

func change_scene(scene_name: String) -> void:
	if scene_name not in scenes:
		push_warning("SceneManager: could not find scene %s" % scene_name)
	get_tree().call_deferred("change_scene_to_packed", scenes[scene_name])
