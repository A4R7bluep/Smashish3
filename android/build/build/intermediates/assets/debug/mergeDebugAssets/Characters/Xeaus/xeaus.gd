extends CharacterBody2D


var facing = 1

# Movement Variables
@export var WALK_SPEED = 200
@export var RUN_SPEED = 400
@export var JUMP_SPEED = -1000 # Negative is up
@export var GRAVITY = 2500
@export var dash_fall_speed = 1

var jump_lock = 0

# Object Variables
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]

# Movement
func _on_input_controller_forward():
	if is_on_floor():
		velocity.x = WALK_SPEED
		animation_tree["parameters/conditions/walk_forward"] = true
		state_machine.travel("walk_forward")


func _on_input_controller_back():
	if is_on_floor():
		velocity.x = WALK_SPEED * -0.8
		animation_tree["parameters/conditions/walk_backward"] = true
		state_machine.travel("walk_backward")


func _on_input_controller_down():
	if is_on_floor():
		velocity.x = 0
		animation_tree["parameters/conditions/crouch"] = true
		state_machine.travel("crouch")


func _on_input_controller_up():
	if is_on_floor():
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
			animation_tree["parameters/conditions/backdash"] = true
			state_machine.travel("backdash")
		else:
			velocity.x = RUN_SPEED
			animation_tree["parameters/conditions/run"] = true
			state_machine.travel("run")
	else:
		if direction.x == -1:
			velocity.x = -RUN_SPEED * 1.5
			dash_fall_speed = 2.5
			animation_tree["parameters/conditions/in_air_dash"] = true
			state_machine.travel("air_dash")
			
		else:
			velocity.x = RUN_SPEED * 1.5
			dash_fall_speed = 2.5
			animation_tree["parameters/conditions/in_air_dash"] = true
			state_machine.travel("air_dash")


# Physics process
func _physics_process(delta):
	animation_tree["parameters/conditions/on_ground"] = is_on_floor()
	animation_tree["parameters/conditions/in_air"] = not is_on_floor()
	
	if not is_on_floor() and velocity.y > 0:
		animation_tree["parameters/conditions/is_falling"] = true
	elif not is_on_floor() and not velocity.y > 0:
		animation_tree["parameters/conditions/is_falling"] = false
	elif is_on_floor():
		animation_tree["parameters/conditions/idle"] = true
	
	if velocity.y > 0:
		velocity.y += (GRAVITY / dash_fall_speed) * delta
	else:
		velocity.y += GRAVITY * delta
	
	move_and_slide()
	
	if is_on_floor():
		velocity.x = 0
	
	dash_fall_speed = 1
	
	animation_tree["parameters/conditions/walk_backward"] = false
	animation_tree["parameters/conditions/walk_forward"] = false
	animation_tree["parameters/conditions/crouch"] = false
	animation_tree["parameters/conditions/run"] = false
	animation_tree["parameters/conditions/backdash"] = false
	animation_tree["parameters/conditions/in_air_dash"] = false


# Attacks
func _on_input_controller_l():
	pass # Replace with function body.


func _on_input_controller_m():
	pass # Replace with function body.


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



func test(state):
	print(state)

