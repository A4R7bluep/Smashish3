extends Node2D

@onready var camera = $Camera2D

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

func _process(delta):
	var xeaus1 = get_node("Xeaus1")
	var xeaus2 = get_node("Xeaus2")
	
	if xeaus1.position.x < xeaus2.position.x:
		xeaus1.facing = 1
		xeaus2.facing = -1
	else:
		xeaus1.facing = -1
		xeaus2.facing = 1
	
	camera.position.x = (xeaus1.position.x + xeaus2.position.x) / 2
	camera.position.y = ((xeaus1.position.y + xeaus2.position.y) / 2) - 100
