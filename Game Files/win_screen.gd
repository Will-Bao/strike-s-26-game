extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if(GlobalVars.winner == 1):
		$Winner.frame = GlobalVars.P1Char
		$Other.frame = GlobalVars.P2Char
	else:
		$Winner.frame = GlobalVars.P2Char
		$Other.frame = GlobalVars.P1Char


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/character_select.tscn")
