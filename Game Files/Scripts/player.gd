extends CharacterBody2D


@export var SPEED:float = 300.0
@export var JUMP_VELOCITY:float = -800.0
@export var strength:float = 100
@export var tap_jump:bool = false
@export var double_jump:bool = false
@export var DOUBLE_VELOCITY:float = -800.0
@export var dash_ability:bool = false
@export var dash_amount:float = 10
@export var dash_decay:float = 0.1
@export var player_num:int
@export var char_num:int
var player1controls = ["up1", "down1", "left1", "right1", "attack1", "dash1", "jump1"]
var player2controls = ["up2", "down2", "left2", "right2", "attack2", "dash2", "jump2"]
var controls
var isAttacking:bool
var state
var speed = 100
var knockback = Vector2.ZERO
var inHitbox:Array[CharacterBody2D]
var damage = 0
var gravity_active:bool
enum control_state {ACTIVE, STUNNED, RESPAWNING}
var current_state = control_state.ACTIVE
var spawnPoints:Array[Vector2]
var double_jump_ready:bool = false
var dash_value = 0

func _ready():
	var spawnPointNodes = get_tree().get_nodes_in_group("Spawn Points")
	for point in spawnPointNodes:
		spawnPoints.append(point.position)
	$AttackArea/AttackRect.visible = false
	isAttacking = false
	if player_num == 1:
		controls = player1controls
		char_num = GlobalVars.P1Char
	else:
		controls = player2controls
		char_num = GlobalVars.P2Char
	$Sprite.sprite_frames = load("res://Assets/char" + str(char_num) + "sprites.tres")
	$AttackArea/Sprite2D.texture = load("res://Assets/Attacks/attack" + str(char_num) + ".png")
	current_state = control_state.ACTIVE
	gravity_active = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and gravity_active:
		velocity += get_gravity() * delta
	
	# Handle jump.
	if ((Input.is_action_just_pressed(controls[0]) and tap_jump) or Input.is_action_just_pressed(controls[6])) and is_on_floor() and current_state == control_state.ACTIVE:
		velocity.y = JUMP_VELOCITY
	if ((Input.is_action_just_pressed(controls[0]) and tap_jump) or Input.is_action_just_pressed(controls[6])) and double_jump and double_jump_ready and !is_on_floor() and current_state == control_state.ACTIVE:
		velocity.y = DOUBLE_VELOCITY
		double_jump_ready = false
	if is_on_floor() and !double_jump_ready:
		double_jump_ready = true
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if dash_value > 0:
		dash_value -= dash_amount * dash_decay
	var direction = Input.get_axis(controls[2], controls[3])
	if direction and current_state == control_state.ACTIVE:
		velocity.x = direction * (SPEED + dash_value)
		$Sprite.flip_h = (direction == -1)
		$AttackArea.rotation = int(rad_to_deg(direction == -1)) * PI
		state = "walk"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		state = "idle"
		
	#If the down key is pressed, run the attack function.
	if Input.is_action_just_pressed(controls[4]) and current_state == control_state.ACTIVE:
		attack()
	if dash_ability and dash_value == 0 and Input.is_action_just_pressed(controls[5]) and current_state == control_state.ACTIVE:
		dash_value = dash_amount
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
	$AttackArea/Sprite2D.visible = true
	for entity in inHitbox:
		if entity.is_in_group("Players"):
			give_knockback(entity)
	await get_tree().create_timer(0.5).timeout
	$AttackArea/Sprite2D.visible = false
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
	elif state == "respawn" and $Sprite.animation != "respawn":
		$Sprite.animation = "respawn"

func give_knockback(entity):
	entity.damage += strength
	get_tree().current_scene.get_node("BattleUi").update_damage(entity.player_num, entity.damage)
	#print(entity.damage)
	var dir = global_position.direction_to(entity.global_position)
	var knockback_amount = entity.damage
	var knockback_to_give = dir * knockback_amount
	entity.knockback = knockback_to_give
	entity.current_state = control_state.STUNNED
	entity.get_node("KnockbackCooldown").start()

func _on_attack_area_body_entered(body):
	if "Player" in body.name:
		inHitbox.append(body)

func _on_attack_area_body_exited(body):
	if body in inHitbox:
		inHitbox.erase(body)

func _on_knockback_cooldown_timeout():
	if current_state == control_state.STUNNED:
		current_state = control_state.ACTIVE

func KO():
	print(name + " KOed")
	damage = 0
	get_tree().current_scene.get_node("BattleUi").update_damage(player_num, damage)
	velocity = Vector2.ZERO
	current_state = control_state.RESPAWNING
	gravity_active = false
	get_tree().current_scene.updateScore(player_num)
	await get_tree().create_timer(1).timeout
	state = "respawn"
	position = spawnPoints[randi_range(0, spawnPoints.size() - 1)]
	gravity_active = true
	await get_tree().create_timer(1).timeout
	state = "idle"
	current_state = control_state.ACTIVE
