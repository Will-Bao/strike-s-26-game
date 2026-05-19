extends Node

var P1icons = []
var P2icons = []
var player_icons = [Control]
var icon_scene = preload("res://Scenes/Char_UI.tscn")
var players_in_game = []
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in GlobalVars.active_players.size():
		if not GlobalVars.active_players[i] == 0:
			players_in_game.append(i)
	#print(players_in_game)
	if GlobalVars.mode == "stock":
		$TimeLeft.visible = false
	else:
		$TimeLeft.visible = true
	for i in range(4):
		if GlobalVars.active_players[i] > 0:
			var icon = icon_scene.instantiate()
			icon.initialize(i)
			icon.name = "player_icon" + str(i + 1)
			player_icons.append(icon)
			$Player_Icons.add_child(icon)
	$Label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_stock(player, stock):
	player_icons[players_in_game.find(player)].update_stock(stock)

func update_score(player, score):
	player_icons[players_in_game.find(player)].update_stock(score)

func update_damage(player, damage):
	player_icons[players_in_game.find(player)].update_damage(damage)
