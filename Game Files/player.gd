extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -800.0
@export var player_num:int
var player1controls = ["up1", "down1", "left1", "right1"]
var player2controls = ["up2", "down2", "left2", "right2"]
var controls
var isAttacking:bool
var state

func _ready():
	$Area2D/ColorRect.visible = false
	isAttacking = false
	if player_num == 1:
		controls = player1controls
	else:
		controls = player2controls

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed(controls[0]) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis(controls[2], controls[3])
	if direction:
		velocity.x = direction * SPEED
		$Sprite.flip_h = (direction == -1)
		$Area2D.rotation = int(rad_to_deg(direction == -1)) * PI
		state = "walk"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		state = "idle"
		
	
	if Input.is_action_just_pressed(controls[1]):
		attack()
	
	if not is_on_floor():
		state = "jump"
	
	update_animation()
	move_and_slide()

func attack():
	isAttacking = true
	$Area2D/ColorRect.visible = true
	await get_tree().create_timer(0.5).timeout
	$Area2D/ColorRect.visible = false
	isAttacking = false

func update_animation():
	if isAttacking:
		if $Sprite.animation != "attack":
			$Sprite.animation = "attack"
	elif state == "idle" and $Sprite.animation != "idle":
		$Sprite.animation = "idle"
	elif state == "walk" and $Sprite.animation != "walk":
		$Sprite.animation = "walk"
	elif state == "jump" and $Sprite.animation != "jump":
		$Sprite.animation = "jump"
