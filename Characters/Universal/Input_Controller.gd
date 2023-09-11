extends Node


signal QCF
signal HCF
signal QCB
signal HCB
signal DP

signal UP
signal DOWN
signal FORWARD
signal BACK

var inputTimeDefault = 0.1
var inputTime = inputTimeDefault
var inputBuffer = []

var inputTree = {
	"(1, 0)": {
		"(0, -1)": {
			"(1, -1)": "DP",
		},
		"(1, -1)": {
			"(0, -1)": {
				"(-1, -1)": {
					"(-1, 0)": "HCB"
				},
			},
		},
	},
	"(0, -1)": {
		"(1, -1)": {
			"(1, 0)": "QCF"
		},
		"(-1, -1)": {
			"(-1, 0)": "QCB"
		},
	},
	"(-1, 0)": {
		"(-1, -1)": {
			"(0, -1)": {
				"(1, -1)": {
					"(1, 0)": "HCF"
				},
			},
		},
	},
}

func navigate_tree():
	var currentPath = inputTree
	
	for arrIndex in range(len(inputBuffer)):
#		print(arrIndex)
		if str(inputBuffer[arrIndex]) in ["(1, 0)", "(0, -1)", "(-1, 0)"]:
			for treeItem in currentPath:
				if currentPath.has(str(inputBuffer[arrIndex])):
					if arrIndex == len(inputBuffer) -1:
						currentPath = currentPath[str(inputBuffer[arrIndex])]
						print(currentPath)
						if currentPath in ["HCF", "HCB", "QCB", "QCF", "DP"]:
							print(currentPath)
	
#	print(inputBuffer)
#	if len(inputBuffer) > 1:
#		for i in range(len(inputBuffer)):
#			var currentPath = {}
#			if inputTree.has(str(inputBuffer[i])):
#				currentPath = inputTree[str(inputBuffer[i])]
#				if currentPath.has(str(inputBuffer[i + 1])):
#					currentPath = inputTree[str(inputBuffer[i + 1])]
#					print(currentPath)


func _process(delta):
	#Input
	var Char_Right = Input.get_action_strength("Char_Right")
	var Char_Left = Input.get_action_strength("Char_Left")
	var Char_Down = Input.get_action_strength("Char_Down")
	var Char_Up = Input.get_action_strength("Char_Up")
	
	var Char_Light = Input.get_action_strength("Char_Light")
	var Char_Med = Input.get_action_strength("Char_Med")
	var Char_Heavy = Input.get_action_strength("Char_Heavy")
	var Char_Sys = Input.get_action_strength("Char_Sys")
	var Char_Dash = Input.get_action_strength("Char_Dash")
	
	var CurrentVector = Vector2(Char_Right - Char_Left, Char_Up - Char_Down)
	
	
	if inputBuffer.back() == null or inputBuffer.back() != CurrentVector:
		inputBuffer.append(CurrentVector)
		inputTime = inputTimeDefault
	
	inputTime -= delta

	if inputTime <= 0:
#		print(inputBuffer)
		navigate_tree()
		inputBuffer = []
		inputTime = inputTimeDefault
