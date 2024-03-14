extends Control

@onready var global = get_node("/root/Global")

var maxhealth1
var maxhealth2
var maxtime = 120

@onready var combo1 = $Player1Health/ComboHealth1
@onready var health1 = $Player1Health/Health1
@onready var meter1 = $Player1Meter/Meter1
@onready var rounds1 = $Player1Rounds/RoundStocks1
@onready var combo_player1 = $Player1Health/AnimationPlayer1
@onready var combo_anim1 = combo_player1.get_animation("combo_finished")

@onready var combo2 = $Player2Health/ComboHealth2
@onready var health2 = $Player2Health/Health2
@onready var meter2 = $Player2Meter/Meter2
@onready var rounds2 = $Player2Rounds/RoundStocks2
@onready var combo_player2 = $Player2Health/AnimationPlayer2
@onready var combo_anim2 = combo_player2.get_animation("combo_finished")

@onready var time_progress = $RoundTime/TimeProgress
@onready var time_label = $RoundTime/TimeLabel
@onready var timer = $Timer


func connect_signals(character):
	character.health_changed.connect(set_health)
	character.meter_changed.connect(set_meter)
	character.combo_finished.connect(finish_combo)
	character.set_full_health.connect(set_full_health)


func set_full_health(fullhealth, playernumber):
	match playernumber:
		1:
			maxhealth1 = fullhealth
			health1.max_value = maxhealth1
			combo1.max_value = maxhealth1
			health1.value = maxhealth1
			combo1.value = maxhealth1
			var trackid1 = combo_anim1.find_track("ComboHealth1:value", 0)
			var keyid_beginning1 = combo_anim1.track_find_key(trackid1, 0)
			var keyid_end1 = combo_anim1.track_find_key(trackid1, 0.75)
			combo_anim1.track_set_key_value(trackid1, keyid_beginning1, maxhealth1)
			combo_anim1.track_set_key_value(trackid1, keyid_end1, maxhealth1)
		2:
			maxhealth2 = fullhealth
			health2.max_value = maxhealth2
			combo2.max_value = maxhealth2
			health2.value = maxhealth2
			combo2.value = maxhealth2
			var trackid2 = combo_anim2.find_track("ComboHealth1:value", 0)
			var keyid_beginning2 = combo_anim2.track_find_key(trackid2, 0)
			var keyid_end2 = combo_anim2.track_find_key(trackid2, 0.75)
			combo_anim1.track_set_key_value(trackid2, keyid_beginning2, maxhealth1)
			combo_anim1.track_set_key_value(trackid2, keyid_end2, maxhealth1)

func set_health(damage, combo, playernumber):
	match playernumber:
		1:
			health1.value -= damage
			combo1.value = health1.value + combo
		2:
			health2.value -= damage
			combo2.value = health2.value + combo

func set_meter(meterAdded, playernumber):
	match playernumber:
		1:
			meter1.value += meterAdded
		2:
			meter2.value += meterAdded

func finish_combo(playernumber):
	match playernumber:
		1:
			var trackid = combo_anim1.find_track("ComboHealth1:value", 0)
			var keyid_beginning = combo_anim1.track_find_key(trackid, 0)
			var keyid_end = combo_anim1.track_find_key(trackid, 0.75)
			
			combo_anim1.track_set_key_value(trackid, keyid_beginning, combo1.value)
			combo_anim1.track_set_key_value(trackid, keyid_end, health1.value)
			combo_player1.play("combo_finished")
		2:
			var trackid = combo_anim2.find_track("ComboHealth2:value", 0)
			var keyid_beginning = combo_anim2.track_find_key(trackid, 0)
			var keyid_end = combo_anim2.track_find_key(trackid, 0.75)
			
			combo_anim2.track_set_key_value(trackid, keyid_beginning, combo2.value)
			combo_anim2.track_set_key_value(trackid, keyid_end, health2.value)
			combo_player2.play("combo_finished")

func set_rounds():
	rounds1.value = global.char1wins
	rounds2.value = global.char2wins

func reset():
	health1.value = maxhealth1
	combo1.value = maxhealth1
	meter1.value = 0
	
	health2.value = maxhealth2
	combo2.value = maxhealth2
	meter2.value = 0
	
	time_progress.value = 0
	timer.start(maxtime)


func _ready():
	timer.start(maxtime)
	time_progress.max_value = maxtime

func _process(delta):
	var timeLeft = timer.time_left
	time_label.text = str(int(timeLeft))
	time_progress.value = timeLeft
