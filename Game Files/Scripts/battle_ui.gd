extends Node

var P1icons = []
var P2icons = []
var player_icons = [Control]
var icon_scene = preload("res://Scenes/Char_UI.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
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
	player_icons[player].update_stock(stock)

func update_score(player, score):
	player_icons[player].update_stock(score)

func update_damage(player, damage):
	player_icons[player].update_damage(damage)
