extends Node2D

var player1score:int
var player2score:int
var gameMode

func _ready():
	gameMode = GlobalVars.mode
	if gameMode == "stock":
		player1score = 3
		player2score = 3
		$BattleUi.stock_setup()
	else:
		player1score = 0
		player2score = 0
		$BattleUi.time_setup()

func _process(delta):
	if(gameMode == "time"):
		$BattleUi/TimeLeft.text = "Time Left: " + str(int(round($TimeLeft.time_left)))

func updateScore(player:int, points = 1):
	if(gameMode == "stock"):
		#print("Player" + str(player) + " stock decreased by " + str(points))
		if player == 1:
			player1score -= points
		elif player == 2:
			player2score -= points
		if(player == 1 and player1score == 0):
			gameEnd(2)
		elif(player == 2 and player2score == 0):
			gameEnd(1)
		$BattleUi.update_stock(player1score, player2score)
	elif(gameMode == "time"):
		#print("Player" + str(player) + " stock decreased by " + str(points))
		if player == 1:
			player2score += points
		elif player == 2:
			player1score += points
		$BattleUi.update_score(player1score, player2score)


func gameEnd(winner):
	if(winner == 1):
		#$Player2.queue_free()
		GlobalVars.winner = 1
	elif(winner == 2):
		#$Player.queue_free()
		GlobalVars.winner = 2
	else:
		GlobalVars.winner = 0
	Engine.set_time_scale(0.25)
	await get_tree().create_timer(0.3).timeout
	$BattleUi/Label.visible = true
	await get_tree().create_timer(0.5).timeout
	Engine.set_time_scale(1.0)
	get_tree().change_scene_to_file("res://Scenes/win_screen.tscn")
	


func _on_time_left_timeout():
	if(player1score > player2score):
		gameEnd(1)
	elif(player1score < player2score):
		gameEnd(2)
	else:
		gameEnd(0)
