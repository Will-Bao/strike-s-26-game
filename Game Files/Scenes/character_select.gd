extends Node2D

var p1Char = 1
var p2Char = 2
var p3Char = 3
var p4Char = 4
var p1ready:bool = false
var p2ready:bool = false
var p3ready:bool = false
var p4ready:bool = false
var player1controls = ["up1", "down1", "left1", "right1", "attack1", "dash1", "jump1"]
var player2controls = ["up2", "down2", "left2", "right2", "attack2", "dash2", "jump2"]
var player3controls = ["up3", "down3", "left3", "right3", "attack3", "dash3", "jump3"]
var player4controls = ["up4", "down4", "left4", "right4", "attack4", "dash4", "jump4"]
var controller1 = ["cup1", "cdown1", "cleft1", "cright1", "cattack1", "cdash1", "cjump1"]
var controller2 = ["cup2", "cdown2", "cleft2", "cright2", "cattack2", "cdash2", "cjump2"]
var controller3 = ["cup3", "cdown3", "cleft3", "cright3", "cattack3", "cdash3", "cjump3"]
var controller4 = ["cup4", "cdown4", "cleft4", "cright4", "cattack4", "cdash4", "cjump4"]
var charsNum = 4

var select_icon = preload("res://Scenes/select_icon.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	check_controllers(event)
	check_players(event)
	if event.is_action_pressed("ui_accept"):
		if((p1ready or not GlobalVars.active_players[0]) and (p2ready or not GlobalVars.active_players[1]) and (p3ready or not GlobalVars.active_players[2]) and (p4ready or not GlobalVars.active_players[3])):
			GlobalVars.player_chars[0] = p1Char
			GlobalVars.player_chars[1] = p2Char
			GlobalVars.player_chars[2] = p3Char
			GlobalVars.player_chars[3] = p4Char
			GlobalVars.player1controls = player1controls
			GlobalVars.player2controls = player2controls
			GlobalVars.player3controls = player3controls
			GlobalVars.player4controls = player4controls
			get_tree().change_scene_to_file("res://Scenes/level.tscn")
			return
	if event.is_action_pressed(player1controls[5]):
		p1ready = false
		$Label.visible = false
		return
	if event.is_action_pressed(player2controls[5]):
		p2ready = false
		$Label2.visible = false
		return
	if event.is_action_pressed(player1controls[4]):
		p1ready = true
		$Label.visible = true
		return
	if event.is_action_pressed(player2controls[4]):
		p2ready = true
		$Label2.visible = true
		return
	
	if event.is_action_pressed(player3controls[5]):
		p3ready = false
		$Label.visible = false
		return
	if event.is_action_pressed(player4controls[5]):
		p4ready = false
		$Label2.visible = false
		return
	if event.is_action_pressed(player3controls[4]):
		p3ready = true
		$Label.visible = true
		return
	if event.is_action_pressed(player4controls[4]):
		p4ready = true
		$Label2.visible = true
		return
	
	
	if event.is_action_pressed(player1controls[3]):
		if p1ready: return
		p1Char += 1
	if event.is_action_pressed(player1controls[2]):
		if p1ready: return
		p1Char -= 1
	if event.is_action_pressed(player2controls[3]):
		if p2ready: return
		p2Char += 1
	if event.is_action_pressed(player2controls[2]):
		if p2ready: return
		p2Char -= 1
	
	if event.is_action_pressed(player3controls[3]):
		if p3ready: return
		p3Char += 1
	if event.is_action_pressed(player3controls[2]):
		if p3ready: return
		p3Char -= 1
	if event.is_action_pressed(player4controls[3]):
		if p4ready: return
		p4Char += 1
	if event.is_action_pressed(player4controls[2]):
		if p4ready: return
		p4Char -= 1
	
	if p1Char > charsNum:
		p1Char = 1
	elif p1Char < 1:
		p1Char = charsNum
	if p2Char > charsNum:
		p2Char = 1
	elif p2Char < 1:
		p2Char = charsNum
	if p3Char > charsNum:
		p3Char = 1
	elif p3Char < 1:
		p3Char = charsNum
	if p4Char > charsNum:
		p4Char = 1
	elif p4Char < 1:
		p4Char = charsNum
	get_tree().call_group("icons", "update_icon", p1Char, p2Char, p3Char, p4Char)

func check_players(event):
	if GlobalVars.active_players[0] == 0:
		for evnt in GlobalVars.player1controls:
			if event.is_action_pressed(evnt):
				GlobalVars.active_players[0] = 1
				print("P1 active")
				inst_icon(1)
	if GlobalVars.active_players[1] == 0:
		for evnt in GlobalVars.player2controls:
			if event.is_action_pressed(evnt):
				GlobalVars.active_players[1] = 1
				print("P2 active")
				inst_icon(2)
	if GlobalVars.active_players[2] == 0:
		for evnt in GlobalVars.player3controls:
			if event.is_action_pressed(evnt):
				GlobalVars.active_players[2] = 1
				print("P3 active")
				inst_icon(3)
	if GlobalVars.active_players[3] == 0:
		for evnt in GlobalVars.player4controls:
			if event.is_action_pressed(evnt):
				GlobalVars.active_players[3] = 1
				print("P4 active")
				inst_icon(4)

func inst_icon(player:int):
	var icon = select_icon.instantiate()
	icon.get_node("Char_Sprite").char_num = player
	icon.name = "Char_" + str(player) + "_Sprite"
	$Chars_container.add_child(icon)

func check_controllers(event):
	if GlobalVars.player_controllers[0] == 0:
		if not GlobalVars.player_controllers.has(1):
			for evnt in GlobalVars.controller1:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[0] = 1
					GlobalVars.p1Controller = GlobalVars.controller1
					print("P1 assigned controller 1")
					player1controls = controller1
					print(player1controls[1])
		if not GlobalVars.player_controllers.has(2):
			for evnt in GlobalVars.controller2:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[0] = 2
					GlobalVars.p1Controller = GlobalVars.controller2
					print("P1 assigned controller 2")
					player1controls = controller2
		if not GlobalVars.player_controllers.has(3):
			for evnt in GlobalVars.controller3:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[0] = 3
					GlobalVars.p1Controller = GlobalVars.controller3
					print("P1 assigned controller 3")
					player1controls = controller3
		if not GlobalVars.player_controllers.has(4):
			for evnt in GlobalVars.controller4:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[0] = 4
					GlobalVars.p1Controller = GlobalVars.controller4
					print("P1 assigned controller 4")
					player1controls = controller4
	
	elif GlobalVars.player_controllers[1] == 0:
		if not GlobalVars.player_controllers.has(1):
			for evnt in GlobalVars.controller1:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[1] = 1
					GlobalVars.p2Controller = GlobalVars.controller1
					print("P2 assigned controller 1")
					player2controls = controller1
		if not GlobalVars.player_controllers.has(2):
			for evnt in GlobalVars.controller2:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[1] = 2
					GlobalVars.p2Controller = GlobalVars.controller2
					print("P2 assigned controller 2")
					player2controls = controller2
		if not GlobalVars.player_controllers.has(3):
			for evnt in GlobalVars.controller3:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[1] = 3
					GlobalVars.p2Controller = GlobalVars.controller3
					print("P2 assigned controller 3")
					player2controls = controller3
		if not GlobalVars.player_controllers.has(4):
			for evnt in GlobalVars.controller4:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[1] = 4
					GlobalVars.p2Controller = GlobalVars.controller4
					print("P2 assigned controller 4")
					player2controls = controller4
	
	elif GlobalVars.player_controllers[2] == 0:
		if not GlobalVars.player_controllers.has(1):
			for evnt in GlobalVars.controller1:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[2] = 1
					GlobalVars.p3Controller = GlobalVars.controller1
					print("P3 assigned controller 1")
					player3controls = controller1
		if not GlobalVars.player_controllers.has(2):
			for evnt in GlobalVars.controller2:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[2] = 2
					GlobalVars.p3Controller = GlobalVars.controller2
					print("P3 assigned controller 2")
					player3controls = controller2
		if not GlobalVars.player_controllers.has(3):
			for evnt in GlobalVars.controller3:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[2] = 3
					GlobalVars.p3Controller = GlobalVars.controller3
					print("P3 assigned controller 3")
					player3controls = controller3
		if not GlobalVars.player_controllers.has(4):
			for evnt in GlobalVars.controller4:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[2] = 4
					GlobalVars.p3Controller = GlobalVars.controller4
					print("P3 assigned controller 4")
					player3controls = controller4
	
	elif GlobalVars.player_controllers[3] == 0:
		if not GlobalVars.player_controllers.has(1):
			for evnt in GlobalVars.controller1:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[3] = 1
					GlobalVars.p4Controller = GlobalVars.controller1
					print("P4 assigned controller 1")
					player4controls = controller1
		if not GlobalVars.player_controllers.has(2):
			for evnt in GlobalVars.controller2:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[3] = 2
					GlobalVars.p4Controller = GlobalVars.controller2
					print("P4 assigned controller 2")
					player4controls = controller2
		if not GlobalVars.player_controllers.has(3):
			for evnt in GlobalVars.controller3:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[3] = 3
					GlobalVars.p4Controller = GlobalVars.controller3
					print("P4 assigned controller 3")
					player4controls = controller3
		if not GlobalVars.player_controllers.has(4):
			for evnt in GlobalVars.controller4:
				if event.is_action_pressed(evnt):
					GlobalVars.player_controllers[3] = 4
					GlobalVars.p4Controller = GlobalVars.controller4
					print("P4 assigned controller 4")
					player4controls = controller4
