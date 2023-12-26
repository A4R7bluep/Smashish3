extends Node

var full_health = 100
var health = 100
var meter = 0
@export var defense = 0

signal updateHealth(health, playernumber)
signal updateMeter(meter, playernumber)
signal lostRound(playernumber)

func set_health(value, playernumber):
	health -= value
	emit_signal("updateHealth", health, playernumber)
	if health <= 0:
		emit_signal("lostRound", playernumber)

func set_meter(value, playernumber):
	meter += value
	emit_signal("updateMeter", meter, playernumber)
