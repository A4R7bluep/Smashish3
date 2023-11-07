extends Node

signal UP(playernumber)
signal UP_RIGHT(playernumber)
signal RIGHT(playernumber)
signal DOWN_RIGHT(playernumber)
signal DOWN(playernumber)
signal DOWN_LEFT(playernumber)
signal LEFT(playernumber)
signal UP_LEFT(playernumber)
signal SELECT(playernumber)


func _process(delta):
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
	
	var CurrentVector1 = Vector2(Char_Right1 - Char_Left1, Char_Up1 - Char_Down1)
	var CurrentVector2 = Vector2(Char_Right2 - Char_Left2, Char_Up2 - Char_Down2)
	
	match CurrentVector1:
		Vector2.UP:
			emit_signal("UP", 1)
		Vector2.UP + Vector2.RIGHT:
			emit_signal("UP_RIGHT", 1)
		Vector2.RIGHT:
			emit_signal("RIGHT", 1)
		Vector2.DOWN + Vector2.RIGHT:
			emit_signal("DOWN_RIGHT", 1)
		Vector2.DOWN:
			emit_signal("DOWN", 1)
		Vector2.DOWN + Vector2.LEFT:
			emit_signal("DOWN_LEFT", 1)
		Vector2.LEFT:
			emit_signal("LEFT", 1)
		Vector2.UP + Vector2.LEFT:
			emit_signal("UP_LEFT", 1)
	
	match CurrentVector2:
		Vector2.UP:
			emit_signal("UP", 2)
		Vector2.UP + Vector2.RIGHT:
			emit_signal("UP_RIGHT", 2)
		Vector2.RIGHT:
			emit_signal("RIGHT", 2)
		Vector2.DOWN + Vector2.RIGHT:
			emit_signal("DOWN_RIGHT", 2)
		Vector2.DOWN:
			emit_signal("DOWN", 2)
		Vector2.DOWN + Vector2.LEFT:
			emit_signal("DOWN_LEFT", 2)
		Vector2.LEFT:
			emit_signal("LEFT", 2)
		Vector2.UP + Vector2.LEFT:
			emit_signal("UP_LEFT", 2)
	
	if Char_Light1:
		emit_signal("SELECT", 1)
	
	if Char_Light2:
		emit_signal("SELECT", 2)
