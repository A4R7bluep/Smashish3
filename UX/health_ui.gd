extends Control


@onready var health1 = $Player1Health
@onready var health2 = $Player2Health
@onready var meter1 = $Player1Meter
@onready var meter2 = $Player2Meter

func set_health_1(value):
	health1.scale.x = value / 100.0

func set_health_2(value):
	health2.scale.x = value / 100.0

func set_meter_1(value):
	meter1.region_rect = Rect2(0, 0, min(value * 8, 800), 80)

func set_meter_2(value):
	meter2.region_rect = Rect2(0, 0, min(value * 8, 800), 80)

func reset_bars():
	health1.scale.x = 1
	health2.scale.x = 1
	meter1.scale.x = 0
	meter2.scale.x = 0
