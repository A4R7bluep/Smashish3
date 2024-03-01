extends Node2D

@onready var global = get_node("/root/Global")

@onready var camera = $Camera2D
@onready var attackAttr = $AttackAttr
@onready var healthui = $"CanvasLayer/HealthUI"
@onready var canvas_layer = $CanvasLayer

@onready var XeausScene = preload("res://Characters/Xeaus/xeaus.tscn")
var winScreen = preload("res://UX/UIStages/win_screen.tscn").instantiate()

var char1name = "Xeaus"
var char2name = "Xeaus"

var char1
var char2

var area1
var area2

var cameralock = false
var readycounter = 0

var effects = []


func add_xeaus(playernumber):
	match playernumber:
		1:
			var myXeaus = XeausScene.instantiate()
			myXeaus.playernumber = playernumber
			myXeaus.position.x = 100
			self.add_child(myXeaus)
			char1 = get_node("Xeaus" + str(playernumber))
			char1.stats.lostRound.connect(round_end)
			area1 = char1.character_coll
		2:
			var myXeaus = XeausScene.instantiate()
			myXeaus.playernumber = playernumber
			myXeaus.position.x = 1000
			self.add_child(myXeaus)
			char2 = get_node("Xeaus" + str(playernumber))
			char2.stats.lostRound.connect(round_end)
			area2 = char2.character_coll
	
	cameralock = false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	add_characters()
	healthui.set_rounds()


func add_characters():
	match char1name:
		"Xeaus":
			add_xeaus(1)
	match char2name:
		"Xeaus":
			add_xeaus(2)


func _process(delta):
	if cameralock:
		if char1 == null and char2 == null:
			add_characters()
			healthui.reset()
			cameralock = false
	else:
		if char1.position.x < char2.position.x:
			if char1.is_on_floor():
				char1.facing = 1
			if char2.is_on_floor():
				char2.facing = -1
		else:
			if char1.is_on_floor():
				char1.facing = -1
			if char2.is_on_floor():
				char2.facing = 1
		
		camera.position.x = (char1.position.x + char2.position.x) / 2
		camera.position.y = ((char1.position.y + char2.position.y) / 2) - 100
		
		if effects.all(func(e): return e == null):
			effects = []


func return_other_player(playernumber):
	match playernumber:
		1:
			return char2
		2:
			return char1


func round_end(playernumber):
	global.roundwins += 1
	match playernumber:
		1:
			global.char1wins += 1
		2:
			global.char2wins += 1
	
	for effect in effects:
		effect.queue_free()
	
	effects = []
	healthui.set_rounds()
	
	if global.char1wins == 2 or global.char2wins == 2:
		match playernumber:
			1:
				winScreen.winNumber = 2
			2:
				winScreen.winNumber = 1
		
		get_tree().root.add_child(winScreen)
		self.queue_free()
	else:
		cameralock = true
		char1.queue_free()
		char2.queue_free()
