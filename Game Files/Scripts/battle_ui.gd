extends Node

var P1icons = []
var P2icons = []
# Called when the node enters the scene tree for the first time.
func _ready():
	P1icons = [$HBoxContainer/Control3/Heart3, $HBoxContainer/Control2/Heart2, $HBoxContainer/Control/Heart1]
	P2icons = [$HBoxContainer2/Control/Heart3, $HBoxContainer2/Control2/Heart2, $HBoxContainer2/Control3/Heart1]
	update_stock(3, 3)
	$Label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_stock(p1stock, p2stock):
	for i in P1icons.size():
		if(3 - i > p1stock):
			P1icons[i].frame = 0
		else:
			P1icons[i].frame = 1
	for i in P2icons.size():
		if(3 - i > p2stock):
			P2icons[i].frame = 0
		else:
			P2icons[i].frame = 1

func update_score(p1score, p2score):
	$P1Score.text = "P1: " + str(p1score)
	$P2Score.text = "P2: " + str(p2score)

func update_damage(player, damage):
	if(player == 1):
		$P1Damage.text = str(damage)
	else:
		$P2Damage.text = str(damage)

func stock_setup():
	$TimeLeft.visible = false
	$HBoxContainer.visible = true
	$HBoxContainer2.visible = true
	$P1Score.visible = false
	$P2Score.visible = false
func time_setup():
	$TimeLeft.visible = true
	$HBoxContainer.visible = false
	$HBoxContainer2.visible = false
	$P1Score.visible = true
	$P2Score.visible = true
