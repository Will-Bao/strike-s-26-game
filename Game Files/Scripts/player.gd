extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -800.0
@export var player_num:int
@export var char_num:int
var player1controls = ["up1", "down1", "left1", "right1"]
var player2controls = ["up2", "down2", "left2", "right2"]
var controls
var isAttacking:bool
var state
var speed = 100
var knockback = Vector2.ZERO
var inHitbox:Array[CharacterBody2D]
var damage = 0
var strength = 100
var can_control:bool

func _ready():
	$AttackArea/AttackRect.visible = false
	isAttacking = false
	if player_num == 1:
		controls = player1controls
	else:
		controls = player2controls
	$Sprite.sprite_frames = load("res://Assets/char" + str(char_num) + "sprites.tres")
	can_control = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed(controls[0]) and is_on_floor() and can_control:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis(controls[2], controls[3])
	if direction and can_control:
		velocity.x = direction * SPEED
		$Sprite.flip_h = (direction == -1)
		$AttackArea.rotation = int(rad_to_deg(direction == -1)) * PI
		state = "walk"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		state = "idle"
		
	#If the down key is pressed, run the attack function.
	if Input.is_action_just_pressed(controls[1]) and can_control:
		attack()
	#If the player is not on the floor, set their state to "jump"
	if not is_on_floor():
		state = "jump"
	velocity.x += knockback.x
	velocity.y += knockback.y
	knockback = lerp(knockback, Vector2.ZERO, 0.1)
	update_animation()
	move_and_slide()

func attack():
	isAttacking = true
	$AttackArea/AttackRect.visible = true
	for entity in inHitbox:
		if entity.is_in_group("Players"):
			give_knockback(entity)
	await get_tree().create_timer(0.5).timeout
	$AttackArea/AttackRect.visible = false
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

func give_knockback(entity):
	entity.damage += strength
	#print(entity.damage)
	var dir = global_position.direction_to(entity.global_position)
	var knockback_amount = entity.damage
	var knockback_to_give = dir * knockback_amount
	entity.knockback = knockback_to_give
	entity.can_control = false
	entity.get_node("KnockbackCooldown").start()

func _on_attack_area_body_entered(body):
	if "Player" in body.name:
		inHitbox.append(body)

func _on_attack_area_body_exited(body):
	if body in inHitbox:
		inHitbox.erase(body)

func _on_knockback_cooldown_timeout():
	can_control = true
