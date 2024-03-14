extends CharacterBody2D

var facing
var summoner : CharacterBody2D
var effecter : CharacterBody2D
var effect = false
var done = false
var movement_lock = false

@onready var sprite = $facer/AnimatedSprite2D
@onready var facer = $facer
@onready var collision = $facer/XeausFireball/CollisionShape2D
@onready var explosion = $facer/XeausStainExplode/CollisionShape2D
@onready var explosion_area = $facer/XeausStainExplode

signal dying

func _ready():
	if facing == 1:
		facer.scale.y = 1
		facer.rotation_degrees = 0
	elif facing == -1:
		facer.scale.y = -1
		facer.rotation_degrees = 180

func _on_animated_sprite_2d_animation_finished():
	sprite.play("fireball")
	
	if not effect:
		collision.disabled = false
		done = true


func _physics_process(delta):
	if done and !movement_lock:
		velocity.x = 400 * facing
		
		move_and_slide()


func _on_visible_on_screen_enabler_2d_screen_exited():
	dying.emit()
	self.queue_free()


func _on_xeaus_fireball_area_entered(area):
	var body = area.get_parent().get_parent()
	if body != summoner and body != self and area.name == "Hurtbox":
		self.queue_free()
	elif body != summoner and body != self:
		dying.emit()
		self.queue_free()


func explode():
	if effect:
		effecter.hurtbox_mgmt.hit(explosion_area)
		self.queue_free()
	elif done:
		collision.disabled = true
		explosion.disabled = false
		movement_lock = true
		await get_tree().create_timer(0.1).timeout
		self.queue_free()
