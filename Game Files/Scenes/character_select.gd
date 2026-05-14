extends Node2D

var p1Char = 1
var p2Char = 1
var p1ready:bool = false
var p2ready:bool = false
var charsNum = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if(p1ready and p2ready):
			GlobalVars.player_chars[0] = p1Char
			GlobalVars.player_chars[1] = p2Char
			get_tree().change_scene_to_file("res://Scenes/level.tscn")
			return
	if event.is_action_pressed("dash1"):
		p1ready = false
		$Label.visible = false
		return
	if event.is_action_pressed("dash2"):
		p2ready = false
		$Label2.visible = false
		return
	if event.is_action_pressed("attack1"):
		p1ready = true
		$Label.visible = true
		return
	if event.is_action_pressed("attack2"):
		p2ready = true
		$Label2.visible = true
		return
	if event.is_action_pressed("right1"):
		if p1ready: return
		p1Char += 1
	if event.is_action_pressed("left1"):
		if p1ready: return
		p1Char -= 1
	if event.is_action_pressed("right2"):
		if p2ready: return
		p2Char += 1
	if event.is_action_pressed("left2"):
		if p2ready: return
		p2Char -= 1
	if p1Char > charsNum:
		p1Char = 1
	elif p1Char < 1:
		p1Char = charsNum
	if p2Char > charsNum:
		p2Char = 1
	elif p2Char < 1:
		p2Char = charsNum
	get_tree().call_group("icons", "update_icon", p1Char, p2Char)
