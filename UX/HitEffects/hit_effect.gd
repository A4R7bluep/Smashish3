extends Node2D


@onready var gpu_particles_2d = $GPUParticles2D
var world;

func _ready():
	gpu_particles_2d.emitting = true

func _on_gpu_particles_2d_finished():
	queue_free()
