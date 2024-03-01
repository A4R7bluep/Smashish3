extends CharacterBody2D


var facing = 1 # 1 is on left, -1 is on right
var playernumber;

# Movement Variables
@export var WALK_SPEED = 300
@export var RUN_SPEED = 500
@export var JUMP_SPEED = -2000 # Negative is up
@export var GRAVITY = 3000
@export var dash_fall_speed = 1

var jump_lock = 0
var wall_slide = false

# Object Variables
@onready var facer = $facer
@onready var input_controller = $Input_Controller
@onready var animation_tree = $AnimationTree
@onready var character_coll = $Area2D
@onready var stats = $StatController
@onready var state_machine = animation_tree["parameters/playback"]
@onready var global = get_node("/root/Global")
var light_hit = preload("res://UX/HitEffects/light_hit.tscn")

@onready var parent = get_parent()
@onready var attackAttr = $"../AttackAttr"

# Damage Scaling
@export var fullhealth = 300
@export var combo_scaling = 0.125
var combo_damage = 0
var combo_hits = 0

# States
@export var walk_backward = false
@export var walk_forward = false
@export var crouch = false
@export var crouchblock = false
@export var run = false
@export var backdash = false
@export var air_dash = false
@export var attack = false
@export var blocking = false
@export var throw = false
@export var idle = true
@export var gravity_lock = false

var framelock = false

signal health_changed(damage, combo, playernumber)
signal meter_changed(meterAdded, playernumber)
signal combo_finished(playernumber)
signal set_full_health(fullhealth, playernumber)


# Movement
func _on_input_controller_forward():
	if is_on_floor() and (idle or walk_forward) and not (run or backdash):
		velocity.x = WALK_SPEED * facing
		#animation_tree["parameters/conditions/walk_forward"] = true
		walk_forward = true
		#animation_tree["parameters/walkforward/playback"].travel("walkforward")
		state_machine.travel("walkforward")


func _on_input_controller_back():
	if is_on_floor() and (idle or walk_backward) and not (run or backdash):
		velocity.x = WALK_SPEED * -0.8 * facing
		#animation_tree["parameters/conditions/walk_backward"] = true
		walk_backward = true
		blocking = true
		reset_values()
		#animation_tree["parameters/walkbackward/playback"].travel("walkbackward")
		state_machine.travel("walkbackward")


func _on_input_controller_down():
	if is_on_floor() and not (backdash or run):
		velocity.x = 0
		crouch = true
		idle = false
		blocking = false
		reset_values()
		state_machine.travel("crouch")
		animation_tree["parameters/crouch/playback"].travel("crouch")


func _on_input_controller_down_back():
	if is_on_floor() and not backdash:
		velocity.x = 0
		crouch = true
		blocking = true
		idle = false
		state_machine.travel("crouchblock")
		animation_tree["parameters/crouchblock/playback"].travel("crouch_block")


func _on_input_controller_down_forward():
	if is_on_floor() and not (backdash or run):
		velocity.x = 0
		crouch = true
		idle = false
		blocking = false
		reset_values()
		state_machine.travel("crouch")
		animation_tree["parameters/crouch/playback"].travel("crouch")


func _on_input_controller_up():
	if is_on_floor() and not attack:
		velocity.y = JUMP_SPEED
		state_machine.travel("jump")


func _on_input_controller_up_forward():
	if jump_lock != -1:
		velocity.x = RUN_SPEED * facing
	if is_on_floor():
		velocity.y = JUMP_SPEED
		state_machine.travel("jump")
		jump_lock = 1


func _on_input_controller_up_back():
	if jump_lock != 1:
		velocity.x = -RUN_SPEED * facing
	if is_on_floor():
		velocity.y = JUMP_SPEED
		state_machine.travel("jump")
		jump_lock = -1


func _on_input_controller_dash(direction):
	if is_on_floor() and idle:
		if direction.x == -1:
			velocity.x = -RUN_SPEED * facing
			backdash = true
			walk_backward = false
			#state_machine.travel("backdash")
			animation_tree["parameters/backdash/playback"].travel("backdash")
		elif direction.x == 0:
			velocity.x = RUN_SPEED * facing
			run = true
			walk_forward = false
			#state_machine.travel("run")
			animation_tree["parameters/run/playback"].travel("run")
		elif not animation_tree["parameters/conditions/crouch"]:
			velocity.x = RUN_SPEED * facing
			run = true
			walk_forward = false
			#state_machine.travel("run")
			animation_tree["parameters/run/playback"].travel("run")
	elif not is_on_floor():
		if direction.x == -1:
			velocity.x = -RUN_SPEED * 1.5 * facing
			velocity.y = 0
			dash_fall_speed = 5
			air_dash = true
			state_machine.travel("air_dash")
		elif direction.x == 0:
			velocity.x = RUN_SPEED * 1.5 * facing
			velocity.y = 0
			dash_fall_speed = 5
			air_dash = true
			state_machine.travel("air_dash")
		else:
			velocity.x = RUN_SPEED * 1.5 * facing
			velocity.y = 0
			dash_fall_speed = 5
			air_dash = true
			state_machine.travel("air_dash")


# Attacks
func _on_input_controller_l():
	if is_on_floor() and idle:
		#animation_tree["parameters/conditions/attack"] = true
		attack = true
		state_machine.travel("5L")
	else:
		pass


func _on_input_controller_m():
	if is_on_floor() and idle:
		#animation_tree["parameters/conditions/attack"] = true
		attack = true
		state_machine.travel("5M")
	else:
		pass


func _on_input_controller_h():
	pass # Replace with function body.


func _on_input_controller_normal_2m():
	pass # Replace with function body.


func _on_input_controller_normal_6m():
	if is_on_floor() and idle:
		#animation_tree["parameters/conditions/attack"] = true
		attack = true
		walk_forward = false
		state_machine.travel("6M")
	else:
		pass


func _on_input_controller_normal_4m():
	pass # Replace with function body.


func _on_input_controller_qcbl():
	pass # Replace with function body.


func _on_input_controller_normal_2l():
	pass # Replace with function body.


func _on_input_controller_normal_6l():
	pass # Replace with function body.


func _on_input_controller_qcfl():
	pass # Replace with function body.


func _on_input_controller_qcfm():
	pass # Replace with function body.


func _on_input_controller_qcfh():
	pass # Replace with function body.


func _on_input_controller_normal_4h():
	pass # Replace with function body.


func _on_input_controller_hcbh():
	pass # Replace with function body.


func _on_input_controller_qcbh():
	pass # Replace with function body.


func _on_input_controller_qcbm():
	pass # Replace with function body.


func _on_input_controller_normal_6s():
	if is_on_floor() and (idle or walk_forward):
		throw = true
		state_machine.travel("throw")
	else:
		pass


func _on_input_controller_normal_4s():
	if is_on_floor() and (idle or walk_backward):
		throw = true
		state_machine.travel("backthrow")
	else:
		pass


func _ready():
	set_name("Xeaus" + str(playernumber))
	input_controller.playernumber = playernumber
	parent.healthui.connect_signals(self)
	set_full_health.emit(fullhealth, playernumber)
	stats.set_full_health(fullhealth)

# Physics process
func _physics_process(delta):
	if facing == 1:
		facer.scale.y = 1
		facer.rotation_degrees = 0
	elif facing == -1:
		facer.scale.y = -1
		facer.rotation_degrees = 180
	
	animation_tree["parameters/conditions/on_ground"] = is_on_floor()
	animation_tree["parameters/conditions/in_air"] = not is_on_floor()
	
	if not is_on_floor() and velocity.y > 0:
		animation_tree["parameters/conditions/is_falling"] = true
	elif is_on_floor():
		animation_tree["parameters/conditions/is_falling"] = false
	
	if velocity.y > 0:
		velocity.y += (GRAVITY / dash_fall_speed) * delta
	else:
		velocity.y += GRAVITY * delta
	
	if playernumber == 1:
		var area2 = parent.area2
		if character_coll.overlaps_area(area2):
			velocity.x = -150 * facing
	else:
		var area1 = parent.area1
		if character_coll.overlaps_area(area1):
			velocity.x = -150 * facing
	
	if (not attack) or (gravity_lock):
		move_and_slide()
	
	if is_on_floor():
		velocity.x = 0
	
	dash_fall_speed = 1
	
	reset_values()


func reset_values():
	if idle:
		walk_backward = false
		walk_forward = false
		crouch = false
		run = false
		backdash = false
		air_dash = false
		blocking = false
		throw = false
		gravity_lock = false
	
	animation_tree["parameters/conditions/walk_backward"] = walk_backward
	animation_tree["parameters/conditions/walk_forward"] = walk_forward
	animation_tree["parameters/conditions/crouch"] = crouch and not blocking
	animation_tree["parameters/conditions/crouchblock"] = crouch and blocking
	animation_tree["parameters/conditions/run"] = run
	animation_tree["parameters/conditions/backdash"] = backdash
	animation_tree["parameters/conditions/air_dash"] = air_dash
	animation_tree["parameters/conditions/attack"] = attack
	animation_tree["parameters/conditions/throw"] = throw
	animation_tree["parameters/conditions/idle"] = idle
	animation_tree["parameters/conditions/thrown"] = gravity_lock
	
	if is_on_floor() and combo_hits > 0:
		combo_hits = 0
		combo_damage = 0
		combo_finished.emit(playernumber)


func _on_hurtbox_area_entered(area):
	var body = area.get_parent().get_parent()
	# use find parent
	if body != self:
		var bodyName = body.get_name()
		
		if bodyName.begins_with("Xeaus"):
			var values = attackAttr.attack_lookup["Xeaus"][area.name]
			var combo_decay = min(values["Damage"] * combo_hits * combo_scaling, values["Damage"])
			var damage_taken = values["Damage"] - combo_decay
			var hitbox = area.get_node("CollisionShape2D")
			
			if values["AttackLvl"] == "throw":
				gravity_lock = true
				idle = false
				state_machine.travel("thrown")
				self.global_position = hitbox.global_position
				velocity.x = values["KnockbackX"] * -facing
				velocity.y = values["KnockbackY"]
			elif values["AttackLvl"] == "backthrow":
				var other_char = parent.return_other_player(playernumber)
				var x = hitbox.global_position.x - other_char.global_position.x
				global_position.x = -x
				global_position.y = hitbox.global_position.y
				
				facing *= -facing
				gravity_lock = true
				idle = false
				state_machine.travel("thrown")
				self.global_position = hitbox.global_position
				velocity.x = values["KnockbackX"] * -facing
				velocity.y = values["KnockbackY"]
				print("backthrow")
			else:
				if blocking:
					print("blocked")
				elif not damage_taken == 0:
					combo_damage += damage_taken
					
					var hit_effect = light_hit.instantiate()
					parent.effects.append(hit_effect)
					hit_effect.world = parent
					hit_effect.position.x = (self.global_position.x + hitbox.global_position.x) / 1.85
					hit_effect.position.y = hitbox.global_position.y
					#hit_effect.position = area.global_position
					parent.add_child(hit_effect)
					
					stats.set_health(damage_taken, playernumber)
					stats.set_meter(100, playernumber)
					health_changed.emit(damage_taken, combo_damage, playernumber)
					meter_changed.emit(5, playernumber)
					velocity.x = values["KnockbackX"] * -facing
					velocity.y = values["KnockbackY"]
				
		combo_hits += 1


func _on_hitbox_body_entered(body):
	pass

func _on_stat_controller_lost_round(playernumber):
	queue_free()

func test(state):
	#if get_name() == "Xeaus1":
		#print(state)
	pass
