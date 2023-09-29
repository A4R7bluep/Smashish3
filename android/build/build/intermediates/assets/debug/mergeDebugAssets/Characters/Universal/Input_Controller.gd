extends Node

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
signal FORWARD
signal BACK
signal DASH

var inputTimeDefault = 0.5
var inputTime = inputTimeDefault
var inputBuffer = []

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
	var Char_Right = Input.get_action_strength("Char_Right")
	var Char_Left = Input.get_action_strength("Char_Left")
	var Char_Down = Input.get_action_strength("Char_Down")
	var Char_Up = Input.get_action_strength("Char_Up")
	
	var Char_Light = Input.is_action_pressed("Char_Light")
	var Char_Med = Input.is_action_pressed("Char_Med")
	var Char_Heavy = Input.is_action_pressed("Char_Heavy")
	var Char_Sys = Input.is_action_pressed("Char_Sys")
	var Char_Dash = Input.is_action_pressed("Char_Dash")
	
	var facing = get_parent().facing
	
	var CurrentVector = Vector2((Char_Right - Char_Left) * facing, Char_Up - Char_Down)
	
	
	if CurrentVector.y == 1 and CurrentVector.x == 1:
		emit_signal("UP_FORWARD")
	if CurrentVector.y == 1 and CurrentVector.x == -1:
		emit_signal("UP_BACK")
	if CurrentVector.x == 1:
		emit_signal("FORWARD")
	if CurrentVector.x == -1:
		emit_signal("BACK")
	if CurrentVector.y == 1:
		emit_signal("UP")
	if CurrentVector.y == -1:
		emit_signal("DOWN")
	
	if Char_Light:
		inputBuffer.append("L")
		var command = navigate_tree("L")
		emit_signal(str(command))
		inputBuffer = []
		inputTime = inputTimeDefault
	
	if Char_Med:
		inputBuffer.append("M")
		var command = navigate_tree("M")
		emit_signal(str(command))
		inputBuffer = []
		inputTime = inputTimeDefault
	
	if Char_Heavy:
		inputBuffer.append("H")
		var command = navigate_tree("H")
		emit_signal(str(command))
		inputBuffer = []
		inputTime = inputTimeDefault
	
	if Char_Sys:
		inputBuffer.append("S")
		var command = navigate_tree("S")
		emit_signal(str(command))
		inputBuffer = []
		inputTime = inputTimeDefault
	
	if Char_Dash:
		emit_signal("DASH", CurrentVector)
	
	if inputBuffer.back() == null or inputBuffer.back() != CurrentVector:
		inputBuffer.append(CurrentVector)
		inputTime = inputTimeDefault
	
	inputTime -= delta

	if inputTime <= 0:
		inputBuffer = []
		inputTime = inputTimeDefault
