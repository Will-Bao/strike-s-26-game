extends CharacterBody2D


enum ControlState {ACTIVE, STUNNED, RESPAWNING}

@export var all_stats: Array[PlayerStats]
@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -800.0
@export var strength: float = 100
@export var tap_jump: bool = false
@export var double_jump: bool = false
@export var DOUBLE_VELOCITY: float = -800.0
@export var dash_ability: bool = false
@export var dash_amount: float = 10
@export var dash_decay: float = 0.1
@export var player_num: int
@export var char_num: int
@export var is_computer_player:bool

var stats: PlayerStats
var player1controls = ["up1", "down1", "left1", "right1", "attack1", "dash1", "jump1"]
var player2controls = ["up2", "down2", "left2", "right2", "attack2", "dash2", "jump2"]
var player3controls = ["up3", "down3", "left3", "right3", "attack3", "dash3", "jump3"]
var player4controls = ["up4", "down4", "left4", "right4", "attack4", "dash4", "jump4"]
var playerCcontrols = ["upC", "downC", "leftC", "rightC", "attackC", "dashC", "jumpC"]
var controls
var is_attacking: bool
var state: String
var speed = 100
var knockback = Vector2.ZERO
var in_hitbox: Array[CharacterBody2D]
var damage: int = 0
var gravity_active: bool = true
var current_state = ControlState.ACTIVE
var spawn_points: Array[Vector2]
var double_jump_ready:bool = false
var dash_value = 0
var players = []
var canAttack:bool
var recent_attacker:int

func _ready():
	var spawnPointNodes = get_tree().get_nodes_in_group("Spawn Points")
	var players = get_tree().get_nodes_in_group("Players")
	for point in spawnPointNodes:
		spawn_points.append(point.position)
	$AttackArea/AttackRect.visible = false
	is_attacking = false
	if player_num == 1:
		controls = GlobalVars.player1controls
		char_num = GlobalVars.player_chars[0]
	elif player_num == 3:
		controls = GlobalVars.player3controls
		char_num = GlobalVars.player_chars[2]
	elif player_num == 4:
		controls = GlobalVars.player4controls
		char_num = GlobalVars.player_chars[3]
	else:
		controls = GlobalVars.player2controls
		char_num = GlobalVars.player_chars[1]
	if is_computer_player:
		controls = playerCcontrols
	$Sprite.sprite_frames = load("res://Assets/char" + str(char_num) + "sprites.tres")
	$AttackArea/Sprite2D.texture = load("res://Assets/Attacks/attack" + str(char_num) + ".png")
	current_state = control_state.ACTIVE
	gravity_active = true
	canAttack = true

func _physics_process(delta):
	if(is_computer_player):
		get_com_controls()
	# Add the gravity.
	if not is_on_floor() and gravity_active:
		velocity += get_gravity() * delta
	
	# Handle jump.
	if ((Input.is_action_just_pressed(controls[0]) and tap_jump) or Input.is_action_just_pressed(controls[6])) and is_on_floor() and current_state == ControlState.ACTIVE:
		velocity.y = JUMP_VELOCITY
	if ((Input.is_action_just_pressed(controls[0]) and tap_jump) or Input.is_action_just_pressed(controls[6])) and double_jump and double_jump_ready and !is_on_floor() and current_state == ControlState.ACTIVE:
		velocity.y = DOUBLE_VELOCITY
		double_jump_ready = false
	if is_on_floor() and not double_jump_ready:
		double_jump_ready = true
	if dash_value > 0:
		dash_value -= dash_amount * dash_decay
	var direction = Input.get_axis(controls[2], controls[3])
	if direction and current_state == ControlState.ACTIVE:
		velocity.x = direction * (SPEED + dash_value)
		$Sprite.flip_h = (direction == -1)
		$AttackArea.scale.x = direction
		#$AttackArea.rotation = int(rad_to_deg(direction == -1)) * PI
		state = "walk"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		state = "idle"
		
	#If the down key is pressed, run the attack function.
	if Input.is_action_just_pressed(controls[4]) and current_state == control_state.ACTIVE and canAttack:
		attack()
		canAttack = false
		$AttackCooldown.start()
	if dash_ability and dash_value == 0 and Input.is_action_just_pressed(controls[5]) and current_state == control_state.ACTIVE:
		dash_value = dash_amount
	#If the player is not on the floor, set their state to "jump"
	if not is_on_floor():
		state = "jump"
	velocity.x += knockback.x
	#velocity.y += knockback.y
	knockback = lerp(knockback, Vector2.ZERO, 0.1)
	update_animation()
	move_and_slide()

func attack():
	is_attacking = true
	$AttackArea/Sprite2D.visible = true
	for entity in in_hitbox:
		if entity.is_in_group("Players"):
			give_knockback(entity)
	await get_tree().create_timer(0.5).timeout
	$AttackArea/Sprite2D.visible = false
	is_attacking = false

func update_animation():
	if is_attacking:
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
	entity.recent_attacker = player_num
	get_tree().current_scene.get_node("BattleUi").update_damage(entity.player_num, entity.damage)
	#print(entity.damage)
	var dir = global_position.direction_to(entity.global_position)
	var knockback_amount = entity.damage
	var knockback_to_give = dir * knockback_amount
	entity.knockback = knockback_to_give
	entity.current_state = ControlState.STUNNED
	entity.get_node("KnockbackCooldown").start()

func _on_attack_area_body_entered(body: Node2D):
	if body.is_in_group("Players"):
		in_hitbox.append(body)

func _on_attack_area_body_exited(body: Node2D):
	if body in in_hitbox:
		in_hitbox.erase(body)

func _on_knockback_cooldown_timeout():
	if current_state == ControlState.STUNNED:
		current_state = ControlState.ACTIVE

func KO():
	print(name + " KOed")
	damage = 0
	get_tree().current_scene.get_node("BattleUi").update_damage(player_num, damage)
	velocity = Vector2.ZERO
	current_state = ControlState.RESPAWNING
	gravity_active = false
	get_tree().current_scene.updateScore(player_num, recent_attacker)
	if get_tree().current_scene.is_still_in(player_num) == false and GlobalVars.mode == "stock":
		queue_free()
	await get_tree().create_timer(1).timeout
	state = "respawn"
	position = spawn_points[randi_range(0, spawn_points.size() - 1)]
	gravity_active = true
	await get_tree().create_timer(1).timeout
	state = "idle"
	current_state = control_state.ACTIVE

func get_com_controls():
	var target = get_player_target(get_tree().get_nodes_in_group("Players"))
	var maxDist = 150
	if target.position.x > position.x + maxDist:
		Input.action_press(controls[3])
	elif target.position.x < position.x - maxDist:
		Input.action_press(controls[2])
	else:
		Input.action_press(controls[4])
		await get_tree().create_timer(0.01).timeout
		Input.action_release(controls[4])
		Input.action_release(controls[2])
		Input.action_release(controls[3])
	if(target.position.y < position.y - 100 || position.y > 444):
		Input.action_press(controls[6])
		await get_tree().create_timer(0.01).timeout
		Input.action_release(controls[6])

func get_player_target(chars):
	var charInd = chars.find(self)
	chars.remove_at(charInd)
	var target = chars[0]
	for c in chars:
		if position.distance_to(c.position) < position.distance_to(target.position):
			target = c
	return target


func _on_attack_cooldown_timeout():
	canAttack = true
