extends Node2D

var winNumber = 0
@onready var label = $Label

func _ready():
	label.text = "player %s wins" % winNumber

