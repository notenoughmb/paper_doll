extends RayCast3D

@onready var step_target : Node3D = self.get_parent()

func _physics_process(delta):
	var hit_point = get_collision_point()
	if hit_point:
		step_target.global_position = hit_point
