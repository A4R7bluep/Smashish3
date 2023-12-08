extends Node2D

@onready var spriteUp = $up
@onready var spriteUpRight = $up_right
@onready var spriteRight = $right
@onready var spriteDownRight = $down_right
@onready var spriteDown = $down
@onready var spriteDownLeft = $down_left
@onready var spriteLeft = $left
@onready var spriteUpLeft = $up_left

@onready var sprites = [spriteUp, spriteUpRight, spriteRight, spriteDownRight,
				spriteDown, spriteDownLeft, spriteLeft, spriteUpLeft]

var stage = preload("res://Stages/test_stage.tscn").instantiate()

var done1 = false
var done2 = false

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
	
	var selected = [false, false, false, false, false, false, false, false]
	
	match CurrentVector1:
			Vector2.UP:
				selected[0] = true
			Vector2.UP + Vector2.RIGHT:
				selected[1] = true
			Vector2.RIGHT:
				selected[2] = true
			Vector2.DOWN + Vector2.RIGHT:
				selected[3] = true
			Vector2.DOWN:
				selected[4] = true
			Vector2.DOWN + Vector2.LEFT:
				selected[5] = true
			Vector2.LEFT:
				selected[6] = true
			Vector2.UP + Vector2.LEFT:
				selected[7] = true
	
	match CurrentVector2:
			Vector2.UP:
				selected[0] = true
			Vector2.UP + Vector2.RIGHT:
				selected[1] = true
			Vector2.RIGHT:
				selected[2] = true
			Vector2.DOWN + Vector2.RIGHT:
				selected[3] = true
			Vector2.DOWN:
				selected[4] = true
			Vector2.DOWN + Vector2.LEFT:
				selected[5] = true
			Vector2.LEFT:
				selected[6] = true
			Vector2.UP + Vector2.LEFT:
				selected[7] = true
	
	for i in range(len(sprites)):
		if selected[i]:
			sprites[i].texture = load("res://icon.png")
		else:
			sprites[i].texture = load("res://UX/CharSelTest.png")
	
	if Char_Light1:
		match CurrentVector1:
			Vector2.UP:
				stage.char1 = "Xeaus"
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
				stage.char2 = "Xeaus"
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
