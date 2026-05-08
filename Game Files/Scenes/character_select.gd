extends Node2D

var p1Char = 1
var p2Char = 1
var p1ready:bool = false
var p2ready:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if(p1ready and p2ready):
			GlobalVars.P1Char = p1Char
			GlobalVars.P2Char = p2Char
			get_tree().change_scene_to_file("res://Scenes/level.tscn")
			return
	if event.is_action_pressed("down1"):
		p1ready = true
		$Label.visible = true
		return
	if event.is_action_pressed("down2"):
		p2ready = true
		$Label2.visible = true
		return
	if event.is_action_pressed("right1"):
		p1Char += 1
	if event.is_action_pressed("left1"):
		p1Char -= 1
	if event.is_action_pressed("right2"):
		p2Char += 1
	if event.is_action_pressed("left2"):
		p2Char -= 1
	if p1Char > 3:
		p1Char = 1
	elif p1Char < 1:
		p1Char = 3
	if p2Char > 3:
		p2Char = 1
	elif p2Char < 1:
		p2Char = 3
	get_tree().call_group("icons", "update_icon", p1Char, p2Char)
