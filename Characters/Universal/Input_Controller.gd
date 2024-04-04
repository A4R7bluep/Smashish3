extends Node

@onready var global = get_node("/root/Global")

signal L
signal M
signal H

signal QCFL
signal QCFM
signal QCFH
signal QCFS

signal HCFL
signal HCFM
signal HCFH

signal QCBL
signal QCBM
signal QCBH
signal QCBS
signal HCBL
signal HCBM
signal HCBH

signal DPL
signal DPM
signal DPH

signal Normal6L
signal Normal6M
signal Normal6H
signal Normal6S

signal Normal4L
signal Normal4M
signal Normal4H
signal Normal4S

signal Normal2L
signal Normal2M
signal Normal2H

signal UP
signal UP_FORWARD
signal UP_BACK
signal DOWN
signal DOWN_BACK
signal DOWN_FORWARD
signal FORWARD
signal BACK
signal DASH

var playernumber

var inputTimeDefault
var inputTime
var inputBuffer = []

var CurrentVector = Vector2.ZERO

var inputTree = {
	"(1, 0)": {
		"(0, -1)": {
			"(1, -1)": {
				"L": "DPL",
				"M": "DPM",
				"H": "DPH",
			},
		},
		"(1, -1)": {
			"(0, -1)": {
				"(-1, -1)": {
					"(-1, 0)": {
						"L": "HCBL",
						"M": "HCBM",
						"H": "HCBH",
					},
				},
			},
		},
		"L": "Normal6L",
		"M": "Normal6M",
		"H": "Normal6H",
		"S": "Normal6S"
	},
	"(0, -1)": {
		"(1, -1)": {
			"(1, 0)": {
				"L": "QCFL",
				"M": "QCFM",
				"H": "QCFH",
				"S": "QCFS",
			},
		},
		"(-1, -1)": {
			"(-1, 0)": {
				"L": "QCBL",
				"M": "QCBM",
				"H": "QCBH",
				"S": "QCBS",
			},
		},
		"L": "Normal2L",
		"M": "Normal2M",
		"H": "Normal2H",
	},
	"(-1, 0)": {
		"(-1, -1)": {
			"(0, -1)": {
				"(1, -1)": {
					"(1, 0)": {
						"L": "HCFL",
						"M": "HCFM",
						"H": "HCFH",
					},
				},
			},
		},
		"L": "Normal4L",
		"M": "Normal4M",
		"H": "Normal4H",
		"S": "Normal4S",
	},
	"L": "L",
	"M": "M",
	"H": "H",
}


func bufferTimeSet():
	match playernumber:
		1:
			if global.p1CtrlID == 0:
				inputTimeDefault = 0.05
			else:
				inputTimeDefault = 0.1
			inputTime = inputTimeDefault
		2:
			if global.p2CtrlID == 0:
				inputTimeDefault = 0.05
			else:
				inputTimeDefault = 0.1
			inputTime = inputTimeDefault


func navigate_tree(button):
	var currentPath = inputTree
	
	for i in range(len(inputBuffer)):
		if str(inputBuffer[i]) == "(1, 0)" and currentPath.has("(1, 0)"):
			currentPath = currentPath["(1, 0)"]
			
		elif str(inputBuffer[i]) == "(-1, 0)" and currentPath.has("(-1, 0)"):
			currentPath = currentPath["(-1, 0)"]
			
		elif str(inputBuffer[i]) == "(0, -1)" and currentPath.has("(0, -1)"):
			currentPath = currentPath["(0, -1)"]
			
		elif str(inputBuffer[i]) == "(1, -1)" and currentPath.has("(1, -1)"):
			currentPath = currentPath["(1, -1)"]
			
		elif str(inputBuffer[i]) == "(-1, -1)" and currentPath.has("(-1, -1)"):
			currentPath = currentPath["(-1, -1)"]
			
		elif str(inputBuffer[i]) == button and currentPath.has(button):
			currentPath = currentPath[button]
			
		if str(currentPath) in ["DP" + button, "HCB" + button, "HCF" + button, "QCB" + button, "QCF" + button,
			"Normal2" + button, "Normal4" + button, "Normal6" + button, button]:
			return str(currentPath)


func _process(delta):
	#Input
	var right = ""
	var left = ""
	var down = ""
	var up = ""
	var light = ""
	var med = ""
	var heavy = ""
	var sys = ""
	var dash = ""
		
	if playernumber == 1:
		right = "Char_Right1"
		left = "Char_Left1"
		down = "Char_Down1"
		up = "Char_Up1"
		light = "Char_Light1"
		med = "Char_Med1"
		heavy = "Char_Heavy1"
		sys = "Char_Sys1"
		dash = "Char_Dash1"
	elif playernumber == 2:
		right = "Char_Right2"
		left = "Char_Left2"
		down = "Char_Down2"
		up = "Char_Up2"
		light = "Char_Light2"
		med = "Char_Med2"
		heavy = "Char_Heavy2"
		sys = "Char_Sys2"
		dash = "Char_Dash2"
	
	
	var Char_Right = Input.get_action_strength(right)
	var Char_Left = Input.get_action_strength(left)
	var Char_Down = Input.get_action_strength(down)
	var Char_Up = Input.get_action_strength(up)
	
	var Char_Light = Input.is_action_just_pressed(light)
	var Char_Med = Input.is_action_just_pressed(med)
	var Char_Heavy = Input.is_action_just_pressed(heavy)
	var Char_Sys = Input.is_action_just_pressed(sys)
	var Char_Dash = Input.is_action_pressed(dash)
	
	var facing = get_parent().facing
	
	
	CurrentVector = Vector2((Char_Right - Char_Left) * facing, Char_Up - Char_Down)
	#CurrentVector.x *= facing
	
	
	if CurrentVector.x == 1 and CurrentVector.y == 1:
		emit_signal("UP_FORWARD")
	if CurrentVector.x == -1 and CurrentVector.y == 1:
		emit_signal("UP_BACK")
	if CurrentVector.x == 1 and CurrentVector.y == 0:
		emit_signal("FORWARD")
	if CurrentVector.x == -1 and CurrentVector.y == 0:
		emit_signal("BACK")
	if CurrentVector.x == 0 and CurrentVector.y == 1:
		emit_signal("UP")
	if CurrentVector.x == 0 and CurrentVector.y == -1:
		emit_signal("DOWN")
	if CurrentVector.x == -1 and CurrentVector.y == -1:
		emit_signal("DOWN_BACK")
	if CurrentVector.x == 1 and CurrentVector.y == -1:
		emit_signal("DOWN_FORWARD")
	
	if Char_Light and not Char_Dash:
		inputBuffer.append("L")
		var command = navigate_tree("L")
		emit_signal(str(command))
		inputBuffer = []
		inputTime = inputTimeDefault
	
	if Char_Med and not Char_Dash:
		inputBuffer.append("M")
		var command = navigate_tree("M")
		emit_signal(str(command))
		inputBuffer = []
		inputTime = inputTimeDefault
	
	if Char_Heavy and not Char_Dash:
		inputBuffer.append("H")
		var command = navigate_tree("H")
		emit_signal(str(command))
		inputBuffer = []
		inputTime = inputTimeDefault
	
	if Char_Sys and not Char_Dash:
		inputBuffer.append("S")
		var command = navigate_tree("S")
		emit_signal(str(command))
		inputBuffer = []
		inputTime = inputTimeDefault
	
	if Char_Dash:
		emit_signal("DASH", CurrentVector)
	
	if len(inputBuffer) == 0:
		inputBuffer.append(CurrentVector)
		inputTime = inputTimeDefault
	elif inputBuffer.back() == null or inputBuffer.back() != CurrentVector:
		inputBuffer.append(CurrentVector)
		inputTime = inputTimeDefault
	
	inputTime -= delta

	if inputTime <= 0:
		inputBuffer = []
		inputTime = inputTimeDefault
