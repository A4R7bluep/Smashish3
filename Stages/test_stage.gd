extends Node2D

var xeaus1
var xeaus2
var area1
var area2

@onready var camera = $Camera2D
@onready var attackAttr = $AttackAttr

@onready var XeausScene = preload("res://Characters/Xeaus/xeaus.tscn")


func _ready():
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
	if playernumber == 1:
		return xeaus2
	else:
		return xeaus1
