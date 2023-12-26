extends Node2D


@onready var gpu_particles_2d = $GPUParticles2D

func _ready():
	gpu_particles_2d.emitting = true

#func _process(_delta):
	#match gpu_particles_2d.emitting:
		#false:
			#print("dead")
			##queue_free()
		#true:
			#print("emitting")


func _on_gpu_particles_2d_finished():
	queue_free()
