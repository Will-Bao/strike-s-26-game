extends Sprite2D
@export var charnum:int
func _ready():
	pass
	#if animation == "pink":
		#charnum = 1
	#elif animation == "lightblue":
		#charnum = 2
	#elif animation == "blue":
		#charnum = 3
	#elif animation == "gg":
		#charnum = 4
	#frame = 0
	#update_icon(1, 2)
	

func update_icon(p1, p2, p3, p4):
	if p1 == charnum and GlobalVars.active_players[0]:
		$Select1.visible = true
	else:
		$Select1.visible = false
	if p2 == charnum and GlobalVars.active_players[1]:
		$Select2.visible = true
	else:
		$Select2.visible = false
	if p3 == charnum and GlobalVars.active_players[2]:
		$Select3.visible = true
	else:
		$Select3.visible = false
	if p4 == charnum and GlobalVars.active_players[3]:
		$Select4.visible = true
	else:
		$Select4.visible = false
	
