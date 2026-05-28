extends Node2D

var p1Char = 1
var p2Char = 2
var p3Char = 3
var p4Char = 4
var p1ready:bool = false
var p2ready:bool = false
var p3ready:bool = false
var p4ready:bool = false
var keyboard1 = ["up1", "down1", "left1", "right1", "attack1", "dash1", "jump1"]
var keyboard2 = ["up2", "down2", "left2", "right2", "attack2", "dash2", "jump2"]
var keyboard3 = ["up3", "down3", "left3", "right3", "attack3", "dash3", "jump3"]
var keyboard4 = ["up4", "down4", "left4", "right4", "attack4", "dash4", "jump4"]
var controller1 = ["cup1", "cdown1", "cleft1", "cright1", "cattack1", "cdash1", "cjump1"]
var controller2 = ["cup2", "cdown2", "cleft2", "cright2", "cattack2", "cdash2", "cjump2"]
var controller3 = ["cup3", "cdown3", "cleft3", "cright3", "cattack3", "cdash3", "cjump3"]
var controller4 = ["cup4", "cdown4", "cleft4", "cright4", "cattack4", "cdash4", "cjump4"]
var player1controls = []
var player2controls = []
var player3controls = []
var player4controls = []
var charsNum = 4

var select_icon = preload("res://scenes/character_select/select_icon.tscn")
var select_icons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	player1controls = GlobalVars.player1controls
	player2controls = GlobalVars.player2controls
	player3controls = GlobalVars.player3controls
	player4controls = GlobalVars.player4controls
	for i in GlobalVars.active_players.size():
		if GlobalVars.active_players[i] == 1:
			init_player(i + 1, true)

func _input(event):
	check_controllers(event)
	check_players(event)
	if event.is_action_pressed("start_button"):
		if((p1ready or not GlobalVars.active_players[0]) and (p2ready or not GlobalVars.active_players[1]) and (p3ready or not GlobalVars.active_players[2]) and (p4ready or not GlobalVars.active_players[3])):
			GlobalVars.player_chars[0] = p1Char
			GlobalVars.player_chars[1] = p2Char
			GlobalVars.player_chars[2] = p3Char
			GlobalVars.player_chars[3] = p4Char
			GlobalVars.player1controls = player1controls
			GlobalVars.player2controls = player2controls
			GlobalVars.player3controls = player3controls
			GlobalVars.player4controls = player4controls
			set_player_stats()
			SceneManager.change_scene("level")
			return
	var actions = [Callable(self, "p1_actions"), Callable(self, "p2_actions"), Callable(self, "p3_actions"), Callable(self, "p4_actions")]
	for i in GlobalVars.active_players.size():
		if(GlobalVars.active_players[i] == 1):
			#print("Checking active: p" + str(i + 1) + ", is " + str(GlobalVars.active_players[i]) + ". Calling function " + str(i + 1))
			var should_return:bool = actions[i].call(event)
			if(should_return): return
	
	get_tree().call_group("icons", "update_icon", p1Char, p2Char, p3Char, p4Char)

func p1_actions(event):
	if event.is_action_pressed(player1controls[5]):
		p1ready = false
		select_icons[0].get_node("Char_Sprite").get_node("Label").visible = false
		return true
	if event.is_action_pressed(player1controls[4]):
		p1ready = true
		select_icons[0].get_node("Char_Sprite").get_node("Label").visible = true
		return true
	if event.is_action_pressed(player1controls[3]):
		if p1ready: return true
		p1Char += 1
	if event.is_action_pressed(player1controls[2]):
		if p1ready: return true
		p1Char -= 1
	if p1Char > charsNum:
		p1Char = 1
	elif p1Char < 1:
		p1Char = charsNum
	return false

func p2_actions(event):
	if event.is_action_pressed(player2controls[5]):
		p2ready = false
		select_icons[1].get_node("Char_Sprite").get_node("Label").visible = false
		return true
	
	if event.is_action_pressed(player2controls[4]):
		p2ready = true
		select_icons[1].get_node("Char_Sprite").get_node("Label").visible = true
		return true
	
	if event.is_action_pressed(player2controls[3]):
		if p2ready: return true
		p2Char += 1
	if event.is_action_pressed(player2controls[2]):
		if p2ready: return true
		p2Char -= 1
	
	if p2Char > charsNum:
		p2Char = 1
	elif p2Char < 1:
		p2Char = charsNum
	return false

func p3_actions(event):
	if event.is_action_pressed(player3controls[5]):
		p3ready = false
		select_icons[2].get_node("Char_Sprite").get_node("Label").visible = false
		return
	if event.is_action_pressed(player3controls[4]):
		p3ready = true
		select_icons[2].get_node("Char_Sprite").get_node("Label").visible = true
		return true
	if event.is_action_pressed(player3controls[3]):
		if p3ready: return true
		p3Char += 1
	if event.is_action_pressed(player3controls[2]):
		if p3ready: return true
		p3Char -= 1
	if p3Char > charsNum:
		p3Char = 1
	elif p3Char < 1:
		p3Char = charsNum
	return false

func p4_actions(event):
	if event.is_action_pressed(player4controls[5]):
		p4ready = false
		select_icons[3].get_node("Char_Sprite").get_node("Label").visible = false
		return true
	
	if event.is_action_pressed(player4controls[4]):
		p4ready = true
		select_icons[3].get_node("Char_Sprite").get_node("Label").visible = true
		return true
	
	if event.is_action_pressed(player4controls[3]):
		if p4ready: return true
		p4Char += 1
	if event.is_action_pressed(player4controls[2]):
		if p4ready: return true
		p4Char -= 1
	
	if p4Char > charsNum:
		p4Char = 1
	elif p4Char < 1:
		p4Char = charsNum
	return false

func set_player_stats():
	var stat_list:Array[PlayerStats] = [load("res://data/char0stats.tres"), load("res://data/char1stats.tres"), load("res://data/char2stats.tres"), load("res://data/char3stats.tres")]
	for i in stat_list.size():
		stat_list[i].sprite_frames = load("res://data/sprites/char" + str(GlobalVars.player_chars[i]) + "sprites.tres")
		stat_list[i].attack_texture = load("res://assets/art/attacks/attack" + str(GlobalVars.player_chars[i]) + ".png")

func check_players(event):
	if GlobalVars.active_players[0] == 0:
		for evnt in player1controls:
			if event.is_action_pressed(evnt):
				GlobalVars.active_players[0] = 1
				print("P1 active")
				#inst_icon(1)
	if GlobalVars.active_players[1] == 0:
		for evnt in player2controls:
			if event.is_action_pressed(evnt):
				GlobalVars.active_players[1] = 1
				print("P2 active")
				#inst_icon(2)
	if GlobalVars.active_players[2] == 0:
		for evnt in player3controls:
			if event.is_action_pressed(evnt):
				GlobalVars.active_players[2] = 1
				print("P3 active")
				#inst_icon(3)
	if GlobalVars.active_players[3] == 0:
		for evnt in player4controls:
			if event.is_action_pressed(evnt):
				GlobalVars.active_players[3] = 1
				print("P4 active")
				#inst_icon(4)

func init_player(player:int, reinit:bool = false):
	if not reinit:
		GlobalVars.active_players[player - 1] = 1
	print("P" + str(player) + " active")
	var icon = select_icon.instantiate()
	icon.get_node("Char_Sprite").char_num = player
	icon.name = "Char_" + str(player) + "_Sprite"
	select_icons.append(icon)
	$Chars_container.add_child(icon)

func check_controllers(event):
	if GlobalVars.player_controllers[0] == 0:
		if not GlobalVars.player_controllers.has(1):
			for evnt in controller1:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[0] = 1
					GlobalVars.p1Controller = controller1
					print("P1 assigned controller 1")
					player1controls = controller1
		if not GlobalVars.player_controllers.has(2):
			for evnt in controller2:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[0] = 2
					GlobalVars.p1Controller = controller2
					print("P1 assigned controller 2")
					player1controls = controller2
		if not GlobalVars.player_controllers.has(3):
			for evnt in controller3:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[0] = 3
					GlobalVars.p1Controller = controller3
					print("P1 assigned controller 3")
					player1controls = controller3
		if not GlobalVars.player_controllers.has(4):
			for evnt in controller4:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[0] = 4
					GlobalVars.p1Controller = controller4
					print("P1 assigned controller 4")
					player1controls = controller4
		#Keyboard Inputs
		if not GlobalVars.player_controllers.has(11):
			for evnt in keyboard1:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[0] = 11
					GlobalVars.p1Controller = keyboard1
					print("P1 assigned keyboard 1")
					player1controls = keyboard1
					print(player1controls[1])
		if not GlobalVars.player_controllers.has(12):
			for evnt in keyboard2:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[0] = 12
					GlobalVars.p1Controller = keyboard2
					print("P1 assigned keyboard 2")
					player1controls = keyboard2
		if not GlobalVars.player_controllers.has(13):
			for evnt in keyboard3:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[0] = 13
					GlobalVars.p1Controller = keyboard3
					print("P1 assigned keyboard 3")
					player1controls = keyboard3
		if not GlobalVars.player_controllers.has(14):
			for evnt in keyboard4:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[0] = 14
					GlobalVars.p1Controller = keyboard4
					print("P1 assigned keyboard 4")
					player1controls = keyboard4
		if not GlobalVars.player_controllers[0] == 0:
			init_player(1)
	
	elif GlobalVars.player_controllers[1] == 0:
		if not GlobalVars.player_controllers.has(1):
			for evnt in controller1:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[1] = 1
					GlobalVars.p2Controller = controller1
					print("P2 assigned controller 1")
					player2controls = controller1
		if not GlobalVars.player_controllers.has(2):
			for evnt in controller2:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[1] = 2
					GlobalVars.p2Controller = controller2
					print("P2 assigned controller 2")
					player2controls = controller2
		if not GlobalVars.player_controllers.has(3):
			for evnt in controller3:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[1] = 3
					GlobalVars.p2Controller = controller3
					print("P2 assigned controller 3")
					player2controls = controller3
		if not GlobalVars.player_controllers.has(4):
			for evnt in controller4:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[1] = 4
					GlobalVars.p2Controller = controller4
					print("P2 assigned controller 4")
					player2controls = controller4
		#Keyboard Inputs
		if not GlobalVars.player_controllers.has(11):
			for evnt in keyboard1:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[1] = 11
					GlobalVars.p2Controller = keyboard1
					print("P2 assigned keyboard 1")
					player2controls = keyboard1
		if not GlobalVars.player_controllers.has(12):
			for evnt in keyboard2:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[1] = 12
					GlobalVars.p2Controller = keyboard2
					print("P2 assigned keyboard 2")
					player2controls = keyboard2
		if not GlobalVars.player_controllers.has(13):
			for evnt in keyboard3:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[1] = 13
					GlobalVars.p2Controller = keyboard3
					print("P2 assigned keyboard 3")
					player2controls = keyboard3
		if not GlobalVars.player_controllers.has(14):
			for evnt in keyboard4:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[1] = 14
					GlobalVars.p2Controller = keyboard4
					print("P2 assigned keyboard 4")
					player2controls = keyboard4
		if not GlobalVars.player_controllers[1] == 0:
			init_player(2)
	
	elif GlobalVars.player_controllers[2] == 0:
		if not GlobalVars.player_controllers.has(1):
			for evnt in controller1:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[2] = 1
					GlobalVars.p3Controller = controller1
					print("P3 assigned controller 1")
					player3controls = controller1
		if not GlobalVars.player_controllers.has(2):
			for evnt in controller2:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[2] = 2
					GlobalVars.p3Controller = controller2
					print("P3 assigned controller 2")
					player3controls = controller2
		if not GlobalVars.player_controllers.has(3):
			for evnt in controller3:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[2] = 3
					GlobalVars.p3Controller = controller3
					print("P3 assigned controller 3")
					player3controls = controller3
		if not GlobalVars.player_controllers.has(4):
			for evnt in controller4:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[2] = 4
					GlobalVars.p3Controller = controller4
					print("P3 assigned controller 4")
					player3controls = controller4
		#Keyboard Inputs
		if not GlobalVars.player_controllers.has(11):
			for evnt in keyboard1:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[2] = 11
					GlobalVars.p3Controller = keyboard1
					print("P3 assigned keyboard 1")
					player3controls = keyboard1
		if not GlobalVars.player_controllers.has(12):
			for evnt in keyboard2:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[2] = 12
					GlobalVars.p3Controller = keyboard2
					print("P3 assigned keyboard 2")
					player3controls = keyboard2
		if not GlobalVars.player_controllers.has(13):
			for evnt in keyboard3:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[2] = 13
					GlobalVars.p3Controller = keyboard3
					print("P3 assigned keyboard 3")
					player3controls = keyboard3
		if not GlobalVars.player_controllers.has(14):
			for evnt in keyboard4:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[2] = 14
					GlobalVars.p3Controller = keyboard4
					print("P3 assigned keyboard 4")
					player3controls = keyboard4
		if not GlobalVars.player_controllers[2] == 0:
			init_player(3)
	
	elif GlobalVars.player_controllers[3] == 0:
		if not GlobalVars.player_controllers.has(1):
			for evnt in controller1:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[3] = 1
					GlobalVars.p4Controller = controller1
					print("P4 assigned controller 1")
					player4controls = controller1
		if not GlobalVars.player_controllers.has(2):
			for evnt in controller2:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[3] = 2
					GlobalVars.p4Controller = controller2
					print("P4 assigned controller 2")
					player4controls = controller2
		if not GlobalVars.player_controllers.has(3):
			for evnt in controller3:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[3] = 3
					GlobalVars.p4Controller = controller3
					print("P4 assigned controller 3")
					player4controls = controller3
		if not GlobalVars.player_controllers.has(4):
			for evnt in controller4:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[3] = 4
					GlobalVars.p4Controller = controller4
					print("P4 assigned controller 4")
					player4controls = controller4
		#Keyboard Inputs
		if not GlobalVars.player_controllers.has(11):
			for evnt in keyboard1:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[3] = 11
					GlobalVars.p4Controller = keyboard1
					print("P4 assigned keyboard 1")
					player4controls = keyboard1
		if not GlobalVars.player_controllers.has(12):
			for evnt in keyboard2:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[3] = 12
					GlobalVars.p4Controller = keyboard2
					print("P4 assigned keyboard 2")
					player4controls = keyboard2
		if not GlobalVars.player_controllers.has(13):
			for evnt in keyboard3:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[3] = 13
					GlobalVars.p4Controller = keyboard3
					print("P4 assigned keyboard 3")
					player4controls = keyboard3
		if not GlobalVars.player_controllers.has(14):
			for evnt in keyboard4:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[3] = 14
					GlobalVars.p4Controller = keyboard4
					print("P4 assigned keyboard 4")
					player4controls = keyboard4
		if not GlobalVars.player_controllers[3] == 0:
			init_player(4)
