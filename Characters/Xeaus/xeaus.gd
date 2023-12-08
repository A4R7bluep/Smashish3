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

@onready var parent = get_parent()
@onready var attackAttr = $"../AttackAttr"

# Damage Scaling
@export var combo_scaling = 0.25
var combo_hits = 0

# States
@export var walk_backward = false
@export var walk_forward = false
@export var crouch = false
@export var run = false
@export var backdash = false
@export var air_dash = false
@export var attack = false
@export var blocking = false
@export var idle = true


# Movement
func _on_input_controller_forward():
	if is_on_floor():
		velocity.x = WALK_SPEED
		#animation_tree["parameters/conditions/walk_forward"] = true
		walk_forward = true
		state_machine.travel("walk_forward")


func _on_input_controller_back():
	if is_on_floor():
		velocity.x = WALK_SPEED * -0.8
		#animation_tree["parameters/conditions/walk_backward"] = true
		walk_backward = true
		state_machine.travel("walk_backward")


func _on_input_controller_down():
	if is_on_floor():
		velocity.x = 0
		crouch = true
		idle = false
		#animation_tree["parameters/conditions/crouch"] = true
		state_machine.travel("crouch")


func _on_input_controller_down_back():
	if is_on_floor():
		velocity.x = 0
		crouch = true
		blocking = true
		idle = false
		#animation_tree["parameters/conditions/crouch"] = true
		state_machine.travel("crouch_block")


func _on_input_controller_up():
	if is_on_floor() and not attack:
		velocity.y = JUMP_SPEED
		state_machine.travel("jump")


func _on_input_controller_up_forward():
	if jump_lock != -1:
		velocity.x = RUN_SPEED
	if is_on_floor():
		velocity.y = JUMP_SPEED
		state_machine.travel("jump")
		jump_lock = 1


func _on_input_controller_up_back():
	if jump_lock != 1:
		velocity.x = -RUN_SPEED
	if is_on_floor():
		velocity.y = JUMP_SPEED
		state_machine.travel("jump")
		jump_lock = -1


func _on_input_controller_dash(direction):
	if is_on_floor():
		if direction.x == -1:
			velocity.x = -RUN_SPEED
			backdash = true
			state_machine.travel("backdash")
		elif direction.x == 0:
			velocity.x = RUN_SPEED * facing
			run = true
			state_machine.travel("run")
		elif not animation_tree["parameters/conditions/crouch"]:
			velocity.x = RUN_SPEED
			run = true
			state_machine.travel("run")
	else:
		if direction.x == -1:
			velocity.x = -RUN_SPEED * 1.5
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
			velocity.x = RUN_SPEED * 1.5
			velocity.y = 0
			dash_fall_speed = 5
			air_dash = true
			state_machine.travel("air_dash")


func _ready():
	set_name("Xeaus" + str(playernumber))
	input_controller.playernumber = playernumber

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
#	elif is_on_floor():
#		animation_tree["parameters/conditions/idle"] = true
	
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
	
	move_and_slide()
	
	if is_on_floor():
		velocity.x = 0
	
	dash_fall_speed = 1
	
	reset_values()


# Attacks
func _on_input_controller_l():
	if is_on_floor():
		animation_tree["parameters/conditions/attack"] = true
		attack = true
		state_machine.travel("5L")
	else:
		pass


func _on_input_controller_m():
	if is_on_floor():
		animation_tree["parameters/conditions/attack"] = true
		state_machine.travel("5M")
	else:
		pass


func _on_input_controller_h():
	pass # Replace with function body.


func _on_input_controller_normal_2m():
	pass # Replace with function body.


func _on_input_controller_normal_6m():
	pass # Replace with function body.


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


func reset_values():
	animation_tree["parameters/conditions/walk_backward"] = walk_backward
	animation_tree["parameters/conditions/walk_forward"] = walk_forward
	animation_tree["parameters/conditions/crouch"] = crouch
	animation_tree["parameters/conditions/crouchblock"] = crouch and blocking
	animation_tree["parameters/conditions/run"] = run
	animation_tree["parameters/conditions/backdash"] = backdash
	animation_tree["parameters/conditions/air_dash"] = air_dash
	animation_tree["parameters/conditions/attack"] = attack
	#animation_tree["parameters/conditions/block"] = false
	animation_tree["parameters/conditions/idle"] = idle
	
	if is_on_floor():
		combo_hits = 0


func _on_hurtbox_area_entered(area):
	var body = area.get_parent().get_parent()
	if body != self:
		var bodyName = body.get_name()
		
		if bodyName.begins_with("Xeaus"):
			var values = attackAttr.attack_lookup["Xeaus"][area.name]
			var damage_taken = values["Damage"] - min(values["Damage"] * combo_hits * combo_scaling, values["Damage"])
			
			if blocking:
				print("blocked")
			elif not damage_taken == 0:
				stats.set_health(damage_taken, playernumber)
				velocity.x = values["KnockbackX"] * -facing
				velocity.y = values["KnockbackY"]
		
		combo_hits += 1
		
	#	print(attackAttr)

func _on_hitbox_body_entered(body):
	pass

func _on_stat_controller_lost_round(playernumber):
	queue_free()

func test(state):
	#if get_name() == "Xeaus1":
		#print(state)
	pass

