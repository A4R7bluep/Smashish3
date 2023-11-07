extends Control


@onready var bar1 = $Player1Health
@onready var bar2 = $Player2Health

func set_health_1(value):
	bar1.scale.x = value / 100.0

func set_health_2(value):
	bar2.scale.x = value / 100.0
	print(value)

func reset_bars():
	bar1.scale.x = 1
	bar2.scale.x = 1
