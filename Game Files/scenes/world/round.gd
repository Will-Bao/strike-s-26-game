extends Node2D

var player_scores = [0, 0, 0, 0]
var player1score:int
var player2score:int
var gameMode
const player_scene = preload("res://Scenes/player.tscn")

func _ready():
	gameMode = GlobalVars.mode
	if gameMode == "stock":
		player_scores.fill(3)
	else:
		player_scores.fill(0)
	for i in player_scores.size():
		player_scores[i] *= GlobalVars.active_players[i]
	for i in range(4):
		if GlobalVars.active_players[i] > 0:
			var player = player_scene.instantiate()
			player.player_num = i + 1
			player.name = "Player " + str(i + 1)
			player.position = get_node("StartPoint" + str(i + 1)).position
			add_child(player)

func _process(delta):
	if(gameMode == "time"):
		$BattleUi/TimeLeft.text = "Time Left: " + str(int(round($TimeLeft.time_left)))
		$TimeLeft.start()

func updateScore(player:int, attacker:int, points = 1):
	if(gameMode == "stock"):
		#print("Player" + str(player) + " stock decreased by " + str(points))
		player_scores[player - 1] -= 1
		var still_in:int = 0
		for i in player_scores:
			if i > 0:
				still_in += 1
		if still_in == 1:
			gameEnd(greatest_score())
		$BattleUi.update_stock(player, player_scores[player - 1])
	elif(gameMode == "time"):
		player_scores[attacker] += 1
		$BattleUi.update_score(player, player_scores[player - 1])


func gameEnd(winner):
	GlobalVars.winner = winner
	Engine.set_time_scale(0.25)
	await get_tree().create_timer(0.3).timeout
	$BattleUi/Label.visible = true
	await get_tree().create_timer(0.5).timeout
	Engine.set_time_scale(1.0)
	get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
	


func _on_time_left_timeout():
	gameEnd(greatest_score())
	
func is_still_in(player):
	if player_scores[player - 1] > 0:
		return true
	return false

func greatest_score():
	var g = 0
	var tie:bool = false
	for i in range(4):
		if player_scores[i] == player_scores[g]:
			tie = true
		if player_scores[i] > player_scores[g]:
			g = i
			tie = false
	return g + 1


func _on_audio_stream_player_2d_finished():
	$AudioStreamPlayer2D.play()
