extends Node2D

var xeaus1
var xeaus2
var area1
var area2

@onready var camera = $Camera2D
@onready var attackAttr = $AttackAttr
@onready var healthui = $"CanvasLayer/HealthUI"
@onready var canvas_layer = $CanvasLayer

@onready var XeausScene = preload("res://Characters/Xeaus/xeaus.tscn")
var winScreen = preload("res://UX/UIStages/win_screen.tscn").instantiate()

var char1 = ""
var char2 = ""

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	print(char1)
	
	var myXeaus1 = XeausScene.instantiate()
	myXeaus1.playernumber = 1
	myXeaus1.position.x = 100
	self.add_child(myXeaus1)
	
	var myXeaus2 = XeausScene.instantiate()
	myXeaus2.playernumber = 2
	myXeaus2.position.x = 1000
	self.add_child(myXeaus2)
	
	xeaus1 = get_node("Xeaus1")
	xeaus2 = get_node("Xeaus2")
	
	area1 = xeaus1.character_coll
	area2 = xeaus2.character_coll
	xeaus1.stats.updateHealth.connect(set_health_ui)
	xeaus2.stats.updateHealth.connect(set_health_ui)
	xeaus1.stats.updateMeter.connect(set_meter_ui)
	xeaus2.stats.updateMeter.connect(set_meter_ui)
	xeaus1.stats.lostRound.connect(round_end)
	xeaus2.stats.lostRound.connect(round_end)

func _process(delta):
	if xeaus1.position.x < xeaus2.position.x:
		if xeaus1.is_on_floor():
			xeaus1.facing = 1
		if xeaus2.is_on_floor():
			xeaus2.facing = -1
	else:
		if xeaus1.is_on_floor():
			xeaus1.facing = -1
		if xeaus2.is_on_floor():
			xeaus2.facing = 1
	
	camera.position.x = (xeaus1.position.x + xeaus2.position.x) / 2
	camera.position.y = ((xeaus1.position.y + xeaus2.position.y) / 2) - 100

func return_other_player(playernumber):
	match playernumber:
		1:
			return xeaus2
		2:
			return xeaus1

func set_health_ui(health, playernumber):
	match playernumber:
		1:
			healthui.set_health_1(health)
		2:
			healthui.set_health_2(health)

func set_meter_ui(meter, playernumber):
	match playernumber:
		1:
			healthui.set_meter_1(meter)
		2:
			healthui.set_meter_2(meter)

func round_end(playernumber):
	match playernumber:
		1:
			winScreen.winNumber = 2
		2:
			winScreen.winNumber = 1
	
	get_tree().root.add_child(winScreen)
	self.queue_free()

