extends Node


var parent : CharacterBody2D
@onready var attackAttr = get_node("/root/TestStage/AttackAttr")

@export var combo_scaling = 0.125
var combo_damage = 0
var combo_hits = 0

func _ready():
	pass # Replace with function body.


func _process(delta):
	if parent.is_on_floor() and combo_hits > 0:
		combo_hits = 0
		combo_damage = 0
		parent.combo_finished.emit(parent.playernumber)

func hit(area):
	var body = area.get_parent().get_parent()
	# use find parent
	if body != parent:
		var bodyName = body.get_name()
		
		if bodyName.begins_with("XeausFireball"):
			if body.summoner == parent:
				return
		
		if bodyName.begins_with(""):
			var values = attackAttr.attack_lookup["Xeaus"][area.name]
			var combo_decay = min(values["Damage"] * combo_hits * combo_scaling, values["Damage"])
			var damage_taken = values["Damage"] - combo_decay
			var hitbox = area.get_node("CollisionShape2D")
			
			if values["AttackLvl"] == "throw":
				parent.gravity_lock = true
				parent.idle = false
				parent.state_machine.travel("thrown")
				parent.global_position = hitbox.global_position
				
				parent.stats.set_health(damage_taken, parent.playernumber)
				parent.stats.set_meter(100, parent.playernumber)
				parent.health_changed.emit(damage_taken, combo_damage, parent.playernumber)
				parent.meter_changed.emit(5, parent.playernumber)
				parent.velocity.x = values["KnockbackX"] * -parent.facing
				parent.velocity.y = values["KnockbackY"]
			
			elif values["AttackLvl"] == "backthrow":
				var other_char = parent.parent.return_other_player(parent.playernumber)
				var x = hitbox.global_position.x - other_char.global_position.x
				parent.global_position.x = -x
				parent.global_position.y = hitbox.global_position.y
				
				parent.facing *= -parent.facing
				parent.gravity_lock = true
				parent.idle = false
				parent.state_machine.travel("thrown")
				parent.global_position = hitbox.global_position
				
				parent.stats.set_health(damage_taken, parent.playernumber)
				parent.stats.set_meter(100, parent.playernumber)
				parent.health_changed.emit(damage_taken, combo_damage, parent.playernumber)
				parent.meter_changed.emit(5, parent.playernumber)
				parent.velocity.x = values["KnockbackX"] * -parent.facing
				parent.velocity.y = values["KnockbackY"]
				print("backthrow")
			
			elif values["AttackLvl"] == "effect":
				if body.summoner != self:
					if area.name == "XeausFireball":
						if !parent.effects["Stain"]:
							parent.effects["Stain"] = true
							
							var myProjectile = parent.demon_fire.instantiate()
							parent.parent.projectiles.append(myProjectile)
							myProjectile.effecter = parent
							myProjectile.facing = parent.facing
							myProjectile.set_name("StainEffect")
							myProjectile.effect = true
							parent.add_child(myProjectile)
			
			else:
				if parent.blocking:
					print("blocked")
				else:
					combo_damage += damage_taken
					
					var hit_effect = parent.light_hit.instantiate()
					parent.parent.effects.append(hit_effect)
					hit_effect.world = parent.parent
					hit_effect.position.x = (parent.global_position.x + hitbox.global_position.x) / 1.85
					hit_effect.position.y = hitbox.global_position.y
					parent.add_child(hit_effect)
					
					parent.stats.set_health(damage_taken, parent.playernumber)
					parent.stats.set_meter(100, parent.playernumber)
					parent.health_changed.emit(damage_taken, combo_damage, parent.playernumber)
					parent.meter_changed.emit(5, parent.playernumber)
					parent.velocity.x = values["KnockbackX"] * -parent.facing
					parent.velocity.y = values["KnockbackY"]
		
		combo_hits += 1
