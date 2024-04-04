extends Control

@onready var global = get_node("/root/Global")
@onready var sprites = [$Keyboard]

var controllerIDs = Input.get_connected_joypads()
var controllerNum = len(controllerIDs)
var connected = [false, false, false, false]
var leftTaken = false
var rightTaken = false
#var inputDict = {"player1": [], "player2": []}

var charSel = preload("res://UX/UIStages/character_select.tscn").instantiate()

func _ready():
	sprites[0].position.x = 960
	sprites[0].position.y = 400
	if len(controllerIDs) > 0:
		for i in controllerIDs:
			var sprite = preload("res://UX/System/DeviceIcon.tscn").instantiate()
			sprite.name = "Device" + str(i + 1)
			sprite.position.x = 960
			sprite.position.y = 210 * (i + 3)
			sprites.append(sprite)
			self.add_child(sprite)

func _process(delta):
	var left = -1
	var right = -1

	for id in controllerIDs:
		var axis = Input.get_joy_axis(id, JOY_AXIS_LEFT_X)
		var dpadLeft = Input.is_joy_button_pressed(id, JOY_BUTTON_DPAD_LEFT)
		var dpadRight = Input.is_joy_button_pressed(id, JOY_BUTTON_DPAD_RIGHT)
		var direction = (axis > 0.5 or axis < -0.5) or (dpadLeft or dpadRight)
		var buttonA = Input.is_joy_button_pressed(id, JOY_BUTTON_A)
		
		if direction and !connected[id + 1]:
			if axis > 0 or dpadRight:
				right = id + 1
			elif axis < 0 or dpadLeft:
				left = id + 1
		
		if direction and buttonA and !connected[id + 1]:
			if !(((axis > 0.5 or dpadRight) and rightTaken) or ((axis < -0.5 or dpadLeft) and leftTaken)):
				connected[id + 1] = true
				
				var player
				if left == (id + 1):
					player = 1
					leftTaken = true
					global.p1CtrlID = id + 1
				elif right == (id + 1):
					player = 2
					rightTaken = true
					global.p2CtrlID = id + 1
				
				var e_right = InputEventJoypadButton.new()
				e_right.device = id
				e_right.button_index = JOY_BUTTON_DPAD_RIGHT
				InputMap.action_add_event("Char_Right" + str(player), e_right)
				
				var e_left = InputEventJoypadButton.new()
				e_left.device = id
				e_left.button_index = JOY_BUTTON_DPAD_LEFT
				InputMap.action_add_event("Char_Left" + str(player), e_left)
				
				var e_down = InputEventJoypadButton.new()
				e_down.device = id
				e_down.button_index = JOY_BUTTON_DPAD_DOWN
				InputMap.action_add_event("Char_Down" + str(player), e_down)
				
				var e_up = InputEventJoypadButton.new()
				e_up.device = id
				e_up.button_index = JOY_BUTTON_DPAD_UP
				InputMap.action_add_event("Char_Up" + str(player), e_up)
				
				var e_light = InputEventJoypadButton.new()
				e_light.device = id
				e_light.button_index = JOY_BUTTON_X
				InputMap.action_add_event("Char_Light" + str(player), e_light)
				
				var e_med = InputEventJoypadButton.new()
				e_med.device = id
				e_med.button_index = JOY_BUTTON_A
				InputMap.action_add_event("Char_Med" + str(player), e_med)
				
				var e_heavy = InputEventJoypadButton.new()
				e_heavy.device = id
				e_heavy.button_index = JOY_BUTTON_B
				InputMap.action_add_event("Char_Heavy" + str(player), e_heavy)
				
				var e_sys = InputEventJoypadButton.new()
				e_sys.device = id
				e_sys.button_index = JOY_BUTTON_Y
				InputMap.action_add_event("Char_Sys" + str(player), e_sys)
				
				var e_dash = InputEventJoypadButton.new()
				e_dash.device = id
				e_dash.button_index = JOY_BUTTON_RIGHT_SHOULDER
				InputMap.action_add_event("Char_Dash" + str(player), e_dash)
	
	# keyboard
	var keyleft = Input.is_physical_key_pressed(KEY_A)
	var keyright = Input.is_physical_key_pressed(KEY_D)
	var direction = left or right
	var keyU = Input.is_physical_key_pressed(KEY_U)
	
	if direction and !connected[0]:
		if keyright:
			right = 0
		elif keyleft:
			left = 0
	
	if direction and keyU and !connected[0]:
		if keyright and rightTaken:
			pass
		elif keyleft and leftTaken:
			pass
		
		if !((keyright and rightTaken) or (keyleft and leftTaken)):
			connected[0] = true
			
			var player
			if left == 0:
				player = 1
				leftTaken = true
				global.p1CtrlID = 0
			elif right == 0:
				player = 2
				rightTaken = true
				global.p2CtrlID = 0
			
			var e_right = InputEventKey.new()
			e_right.physical_keycode = KEY_D
			InputMap.action_add_event("Char_Right" + str(player), e_right)
			
			var e_left = InputEventKey.new()
			e_left.physical_keycode = KEY_A
			InputMap.action_add_event("Char_Left" + str(player), e_left)
			
			var e_down = InputEventKey.new()
			e_down.physical_keycode = KEY_S
			InputMap.action_add_event("Char_Down" + str(player), e_down)
			
			var e_up = InputEventKey.new()
			e_up.physical_keycode = KEY_W
			InputMap.action_add_event("Char_Up" + str(player), e_up)
			
			var e_light = InputEventKey.new()
			e_light.physical_keycode = KEY_U
			InputMap.action_add_event("Char_Light" + str(player), e_light)
			
			var e_med = InputEventKey.new()
			e_med.physical_keycode = KEY_I
			InputMap.action_add_event("Char_Med" + str(player), e_med)
			
			var e_heavy = InputEventKey.new()
			e_heavy.physical_keycode = KEY_O
			InputMap.action_add_event("Char_Heavy" + str(player), e_heavy)
			
			var e_sys = InputEventKey.new()
			e_sys.physical_keycode = KEY_J
			InputMap.action_add_event("Char_Sys" + str(player), e_sys)
			
			var e_dash = InputEventKey.new()
			e_dash.physical_keycode = KEY_K
			InputMap.action_add_event("Char_Dash" + str(player), e_dash)
		
	
	# sprites
	sprites[0].position.x = 960
	for i in controllerIDs:
		sprites[i + 1].position.x = 960
	
	if left != -1:
		sprites[left].position.x = 460
	if right != -1:
		sprites[right].position.x = 1460
	
	if Input.is_action_pressed("SELECT"):
		get_tree().root.add_child(charSel)
		self.queue_free()
