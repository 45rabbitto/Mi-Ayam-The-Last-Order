extends OmniLight3D

@export var min_energy = 0.2
@export var max_energy = 1.5

func _process(delta):

	light_energy = randf_range(
		min_energy,
		max_energy
	)
