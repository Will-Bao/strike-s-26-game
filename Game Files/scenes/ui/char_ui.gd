extends Control

var stock_icons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	stock_icons = $HBoxContainer.get_children()
	$Damage.visible = true
	update_stock(3)
	if GlobalVars.mode == "stock":
		$HBoxContainer.visible = true
	else:
		$HBoxContainer.visible = false

func initialize(player):
	$Icon.frame = GlobalVars.player_chars[player]

func update_stock(stock):
	for i in stock_icons.size():
		if(i + 1 > stock):
			stock_icons[i].get_child(0).frame = 0
		else:
			stock_icons[i].get_child(0).frame = 1

func update_score(score):
	#$TimedScore.text = score
	pass

func update_damage(damage):
	$Damage.text = str(damage)
