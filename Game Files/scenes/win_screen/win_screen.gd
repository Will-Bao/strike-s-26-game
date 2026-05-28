extends Node2D

var other_sprites:Array[AnimatedSprite2D]

# Called when the node enters the scene tree for the first time.
func _ready():
	var non_winners:Array[int] = []
	for i in GlobalVars.active_players.size():
		non_winners.append(GlobalVars.active_players[i] * GlobalVars.player_chars[i])
	#print(non_winners)
	other_sprites = [$Other, $Other2, $Other3]
	$Winner.frame = GlobalVars.player_chars[GlobalVars.winner - 1]
	non_winners.remove_at(GlobalVars.winner - 1)
	for i in non_winners.size():
		if non_winners[i] == 0:
			other_sprites[i].visible = false
		else:
			other_sprites[i].visible = true
			other_sprites[i].frame = non_winners[i]

func _input(event):
	if event.is_action_pressed("start_button"):
		SceneManager.change_scene("character_select")

func _on_button_pressed():
	SceneManager.change_scene("character_select")
