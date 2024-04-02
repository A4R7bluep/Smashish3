extends Control

@onready var spriteUp = $up/select
@onready var spriteUpRight = $up_right/select
@onready var spriteRight = $right/select
@onready var spriteDownRight = $down_right/select
@onready var spriteDown = $down/select
@onready var spriteDownLeft = $down_left/select
@onready var spriteLeft = $left/select
@onready var spriteUpLeft = $up_left/select

@onready var sprites = [spriteUp, spriteUpRight, spriteRight, spriteDownRight,
				spriteDown, spriteDownLeft, spriteLeft, spriteUpLeft]

var stage = preload("res://Stages/test_stage.tscn").instantiate()

var done1 = false
var done2 = false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(_delta):
	var Char_Right1 = Input.get_action_strength("Char_Right1")
	var Char_Left1 = Input.get_action_strength("Char_Left1")
	var Char_Down1 = Input.get_action_strength("Char_Down1")
	var Char_Up1 = Input.get_action_strength("Char_Up1")
	var Char_Light1 = Input.is_action_pressed("Char_Light1")
	
	var Char_Right2 = Input.get_action_strength("Char_Right2")
	var Char_Left2 = Input.get_action_strength("Char_Left2")
	var Char_Down2 = Input.get_action_strength("Char_Down2")
	var Char_Up2 = Input.get_action_strength("Char_Up2")
	var Char_Light2 = Input.is_action_pressed("Char_Light2")
	
	var CurrentVector1 = Vector2(Char_Right1 - Char_Left1, Char_Down1 - Char_Up1)
	var CurrentVector2 = Vector2(Char_Right2 - Char_Left2, Char_Down2 - Char_Up2)
	
	var selectedP1 = [false, false, false, false, false, false, false, false]
	var selectedP2 = [false, false, false, false, false, false, false, false]
	
	if !done1:
		match CurrentVector1:
			Vector2.UP:
				selectedP1[0] = true
			Vector2.UP + Vector2.RIGHT:
				selectedP1[1] = true
			Vector2.RIGHT:
				selectedP1[2] = true
			Vector2.DOWN + Vector2.RIGHT:
				selectedP1[3] = true
			Vector2.DOWN:
				selectedP1[4] = true
			Vector2.DOWN + Vector2.LEFT:
				selectedP1[5] = true
			Vector2.LEFT:
				selectedP1[6] = true
			Vector2.UP + Vector2.LEFT:
				selectedP1[7] = true
	
	if !done2:
		match CurrentVector2:
			Vector2.UP:
				selectedP2[0] = true
			Vector2.UP + Vector2.RIGHT:
				selectedP2[1] = true
			Vector2.RIGHT:
				selectedP2[2] = true
			Vector2.DOWN + Vector2.RIGHT:
				selectedP2[3] = true
			Vector2.DOWN:
				selectedP2[4] = true
			Vector2.DOWN + Vector2.LEFT:
				selectedP2[5] = true
			Vector2.LEFT:
				selectedP2[6] = true
			Vector2.UP + Vector2.LEFT:
				selectedP2[7] = true
	
	for i in range(len(sprites)):
		if selectedP1[i] and selectedP2[i]:
			sprites[i].texture = load("res://UX/CharacterSel/Player1n2Border.png")
			
		elif selectedP1[i] and !selectedP2[i]:
			sprites[i].texture = load("res://UX/CharacterSel/Player1Border.png")
		
		elif !selectedP1[i] and selectedP2[i]:
			sprites[i].texture = load("res://UX/CharacterSel/player2border.png")
		
		elif !selectedP1[i] and !selectedP2[i]:
			sprites[i].texture = load("res://UX/CharacterSel/BlankBorder.png")
	
	if Char_Light1:
		match CurrentVector1:
			Vector2.UP:
				stage.char1name = "Xeaus"
				done1 = true
			Vector2.UP + Vector2.RIGHT:
				pass
			Vector2.RIGHT:
				pass
			Vector2.DOWN + Vector2.RIGHT:
				pass
			Vector2.DOWN:
				pass
			Vector2.DOWN + Vector2.LEFT:
				pass
			Vector2.LEFT:
				pass
			Vector2.UP + Vector2.LEFT:
				pass

	if Char_Light2:
		match CurrentVector2:
			Vector2.UP:
				stage.char2name = "Xeaus"
				done2 = true
			Vector2.UP + Vector2.RIGHT:
				pass
			Vector2.RIGHT:
				pass
			Vector2.DOWN + Vector2.RIGHT:
				pass
			Vector2.DOWN:
				pass
			Vector2.DOWN + Vector2.LEFT:
				pass
			Vector2.LEFT:
				pass
			Vector2.UP + Vector2.LEFT:
				pass
	
	if done1 and done2:
		get_tree().root.add_child(stage)
		self.queue_free()
