extends AnimatedSprite2D

@export var isP1: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	if isP1:
		frame = 1
	else:
		frame = 2


func update_icon(p1, p2):
	if isP1:
		frame = p1
	else:
		frame = p2
	
