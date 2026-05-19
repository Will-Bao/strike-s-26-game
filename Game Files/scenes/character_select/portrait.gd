extends AnimatedSprite2D

@export var char_num:int

# Called when the node enters the scene tree for the first time.
func _ready():
	frame = char_num


func update_icon(p1, p2, p3, p4):
	if char_num == 1:
		frame = p1
	elif char_num == 2:
		frame = p2
	elif char_num == 3:
		frame = p3
	elif char_num == 4:
		frame = p4
	
