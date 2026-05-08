extends AnimatedSprite2D
var charnum:int
func _ready():
	if animation == "pink":
		charnum = 1
	elif animation == "lightblue":
		charnum = 2
	elif animation == "blue":
		charnum = 3
	frame = 0
	update_icon(1, 2)
	

func update_icon(p1, p2):
	frame = int(p1 == charnum) + (int(p2 == charnum) * 2)
	
