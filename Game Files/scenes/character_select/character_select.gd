extends Node2D

const MIN_CHAR: int = 1
const MAX_CHAR: int = 3

var p1_char: int = 1
var p2_char: int = 1
var p1_ready: bool = false
var p2_ready: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and p1_ready and p2_ready:
		GlobalVars.P1Char = p1_char
		GlobalVars.P2Char = p2_char
		SceneManager.change_scene("level")
		return

	if event.is_action_pressed("attack1"):
		p1_ready = true
		$Label.visible = true
	elif event.is_action_pressed("dash1"):
		p1_ready = false
		$Label.visible = false

	if event.is_action_pressed("attack2"):
		p2_ready = true
		$Label2.visible = true
	elif event.is_action_pressed("dash2"):
		p2_ready = false
		$Label2.visible = false
	
	if not p1_ready:
		if event.is_action_pressed("right1"):
			p1_char += 1
		elif event.is_action_pressed("left1"):
			p1_char -= 1

	if not p2_ready:
		if event.is_action_pressed("right2"):
			p2_char += 1
		elif event.is_action_pressed("left2"):
			p2_char -= 1
	
	p1_char = wrapi(p1_char, MIN_CHAR, MAX_CHAR + 1)
	p2_char = wrapi(p2_char, MIN_CHAR, MAX_CHAR + 1)
	
	get_tree().call_group("icons", "update_icon", p1_char, p2_char)
