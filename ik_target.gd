extends Marker3D

@export var step_target : Marker3D
@export var step_distance : float = 3.0

@export var adjacent_target : Marker3D
@export var diagonal_target : Marker3D

var is_stepping := false

func _process(delta):
	if !is_stepping and !adjacent_target.is_stepping and (global_position.distance_to(step_target.global_position)) > step_distance:
		step()
		diagonal_target.step()

func step():
	var target_pos = step_target.global_position
	var halfway = (global_position + step_target.global_position) / 2
	is_stepping = true
	
	var t = get_tree().create_tween()
	t.tween_property(self, "global_position", halfway + owner.basis.y, 0.1)
	t.tween_property(self, "global_position", target_pos, 0.1)
	t.tween_callback(func(): is_stepping = false)
