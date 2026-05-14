extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if(GlobalVars.winner == 1):
		$Winner.frame = GlobalVars.player_chars[0]
		$Other.frame = GlobalVars.player_chars[1]
	else:
		$Winner.frame = GlobalVars.player_chars[1]
		$Other.frame = GlobalVars.player_chars[0]


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/character_select.tscn")
